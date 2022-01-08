//
//  WKText.swift
//  Reed
//
//  Created by Roger Luo on 8/7/21.
//  Copyright © 2021 Roger Luo. All rights reserved.
//

import Combine
import SwiftUI
import WebKit

private enum WKTextError: Error {
    case scriptError(String)
}

private enum ScrollCursorPosition {
    case top
    case middle
    case bottom
}

struct WKText: UIViewRepresentable {
    let topSpinner = UIActivityIndicatorView(style: .large)
    let bottomSpinner = UIActivityIndicatorView(style: .large)
    
    @StateObject var viewModel: WKTextViewModel
    let switchSectionHandler: (Bool) -> Void
    let definerResultHandler: ([DefinitionDetails]) -> Void
    let isScrollEnabled: Bool
    
    var webView: WKWebView { viewModel.webView }
    
    init(
        processedContentPublisher: AnyPublisher<ProcessedContent?, Never>,
        definerResultHandler: @escaping ([DefinitionDetails]) -> Void,
        switchSectionHandler: @escaping (Bool) -> Void = {_ in },
        isScrollEnabled: Bool = true
    ) {
        self._viewModel = StateObject(
            wrappedValue: WKTextViewModel(processedContentPublisher: processedContentPublisher)
        )
        self.switchSectionHandler = switchSectionHandler
        self.definerResultHandler = definerResultHandler
        self.isScrollEnabled = isScrollEnabled
    }
    
    func makeUIView(context: UIViewRepresentableContext<WKText>) -> UIView {
        let contentController = webView.configuration.userContentController
        contentController.add(context.coordinator, name: "handleTapWord")
        webView.scrollView.delegate = context.coordinator
        do {
            let addClickHandlersFile = try readFile(name: "AddClickHandlers", ext: "js")
            let addClickHandlersScript = WKUserScript(
                source: addClickHandlersFile,
                injectionTime: .atDocumentEnd,
                forMainFrameOnly: false
            )
            contentController.addUserScript(addClickHandlersScript)
        } catch {
            print(error.localizedDescription)
        }
        
        let view = UIView()
        setupLoadingIndicators(for: view)
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(
            webView: webView,
            definerResultHandler: definerResultHandler,
            switchSectionHandler: switchSectionHandler,
            startSpinningHandler: startSpinningHandler(offset:)
        )
    }
    
    private func readFile(name: String, ext: String) throws -> String {
        if let url = Bundle.main.url(forResource: name, withExtension: ext) {
            do {
                let contents = try String(contentsOf: url)
                return contents
            } catch {
                throw WKTextError.scriptError("Unable to read \(name).\(ext).")
            }
        }
        throw WKTextError.scriptError("Unable to find \(name).\(ext).")
    }
    
    class Coordinator: NSObject, WKScriptMessageHandler, UIScrollViewDelegate {
        let SWITCH_SECTION_DRAG_OFFSET: CGFloat = 80
        
        let dictionaryFetcher = DictionaryFetcher()
        let webView: WKWebView
        let definerResultHandler: ([DefinitionDetails]) -> Void
        let switchSectionHandler: (Bool) -> Void
        let startSpinningHandler: (CGFloat) -> Void

        var shouldSwitchSection = false
        private var scrollCursorStartScrollPosition: ScrollCursorPosition = .middle

        init(
            webView: WKWebView,
            definerResultHandler: @escaping ([DefinitionDetails]) -> Void,
            switchSectionHandler: @escaping (Bool) -> Void,
            startSpinningHandler: @escaping (CGFloat) -> Void
        ) {
            self.webView = webView
            self.definerResultHandler = definerResultHandler
            self.switchSectionHandler = switchSectionHandler
            self.startSpinningHandler = startSpinningHandler
        }
        
        func userContentController(
            _ userContentController: WKUserContentController,
            didReceive message: WKScriptMessage
        ) {
            guard let dict = message.body as? [String : AnyObject] else { return }
            if let word = dict["word"] {
                defineSelection(from: word as! String)
            }
        }
        
        func defineSelection(from tappedWord: String) {
            let fetchResults = self.dictionaryFetcher.fetchEntries(of: tappedWord)
            var entries = [DefinitionDetails]()
            for result in fetchResults {
                var terms = [Term]()
                var definitions = [Definition]()
                var primaryReading = ""
                if result.readings[0].terms.endIndex > 0
                    && result.readings[0].terms[0] == tappedWord
                {
                    primaryReading = result.readings[0].reading
                }
                for reading in result.readings {
                    for term in reading.terms {
                        terms.append(Term(reading: reading.reading, term: term))
                    }
                }
                if primaryReading != "" {
                    terms.removeFirst()
                }
                for sense in result.definitions {
                    var definition = ""
                    for gloss in sense.glosses {
                        definition += gloss + ", "
                    }
                    definition.removeLast(2)
                    var specicificLexemes = ""
                    if !sense.specificLexemes.isEmpty {
                        for specific in sense.specificLexemes {
                            specicificLexemes += specific + ", "
                        }
                        specicificLexemes.removeLast(2)
                    }
                    definitions.append(Definition(
                        specicificLexemes: specicificLexemes,
                        definition: definition
                    ))
                }
                entries.append(DefinitionDetails(
                    title: tappedWord,
                    primaryReading: primaryReading,
                    terms: terms,
                    definitions: definitions
                ))
            }
            self.definerResultHandler(entries)
        }
                
        func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
            let isDragOffsetPastThreshold =
                scrollView.contentOffset.y < -SWITCH_SECTION_DRAG_OFFSET
                    || scrollView.contentOffset.y > scrollView.contentSize.height
                        - scrollView.frame.size.height + SWITCH_SECTION_DRAG_OFFSET
            if validateScrollCursorStartPositionForSectionChange(scrollView: scrollView)
                && isDragOffsetPastThreshold {
                if !decelerate {
                    executeActionAtTheEnd(of: scrollView)
                } else {
                    shouldSwitchSection = true
                }
            } else {
                shouldSwitchSection = false
            }
        }

        func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
            setScrollCursorPosition(scrollView: scrollView)
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            if validateScrollCursorStartPositionForSectionChange(scrollView: scrollView) {
                startSpinningHandler(scrollView.contentOffset.y)
            }
        }

        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            if shouldSwitchSection {
                executeActionAtTheEnd(of: scrollView)
            }
        }

        private func executeActionAtTheEnd(of scrollView: UIScrollView) {
            // if the argument is false for switchSectionHandler, switch to previous section
            // else if the argument is true, switch to the next section
            if scrollCursorStartScrollPosition == ScrollCursorPosition.top {
                switchSectionHandler(false)
            } else if scrollCursorStartScrollPosition == ScrollCursorPosition.bottom {
                switchSectionHandler(true)
            }
        }
        
        private func setScrollCursorPosition(scrollView: UIScrollView) {
            if scrollView.contentOffset.y == 0 {
                scrollCursorStartScrollPosition = .top
            } else if scrollView.contentOffset.y == scrollView.contentSize.height - scrollView.frame.size.height {
                scrollCursorStartScrollPosition = .bottom
            } else {
                scrollCursorStartScrollPosition = .middle
            }
        }
        
        private func validateScrollCursorStartPositionForSectionChange(scrollView: UIScrollView) -> Bool {
            // checks if scroll cursor is at top
            if scrollView.contentOffset.y <= 0 {
                return scrollCursorStartScrollPosition == ScrollCursorPosition.top
            }
            
            // checks if scroll cursor is at bottom
            if scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height {
                return scrollCursorStartScrollPosition == ScrollCursorPosition.bottom
            }
            
            // returns false if scroll cursor start at middle
            return false
        }
             
    }
}

// Loading indicator logic
extension WKText {
    func setupLoadingIndicators(for view: UIView) {
        view.addSubview(topSpinner)
        topSpinner.stopAnimating()
        topSpinner.hidesWhenStopped = true
        topSpinner.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 0)
        topSpinner.style = .medium
        topSpinner.translatesAutoresizingMaskIntoConstraints = false
        topSpinner.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        topSpinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        topSpinner.heightAnchor.constraint(equalToConstant: 0).isActive = true

        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.topAnchor.constraint(equalTo: topSpinner.bottomAnchor).isActive = true
        webView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        webView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        webView.scrollView.isScrollEnabled = isScrollEnabled
        
        view.addSubview(bottomSpinner)
        bottomSpinner.stopAnimating()
        bottomSpinner.hidesWhenStopped = true
        bottomSpinner.style = .medium
        bottomSpinner.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 0)
        bottomSpinner.translatesAutoresizingMaskIntoConstraints = false
        bottomSpinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        bottomSpinner.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        bottomSpinner.heightAnchor.constraint(equalToConstant: 0).isActive = true
    }
    
    func startSpinningHandler(offset: CGFloat) {
        if (webView.scrollView.isScrollEnabled) {
            if offset < 0 {
                topSpinner.constraints.last?.constant = -offset
                topSpinner.startAnimating()
            } else if offset > webView.scrollView.contentSize.height - webView.frame.size.height {
                bottomSpinner.constraints.last?.constant = offset - (webView.scrollView.contentSize.height - webView.frame.size.height)
                bottomSpinner.startAnimating()
            } else {
                topSpinner.stopAnimating()
                bottomSpinner.stopAnimating()
            }
        }
    }
}

