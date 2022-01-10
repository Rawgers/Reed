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
    case fits
    case top
    case middle
    case bottom
}

struct WKText: UIViewRepresentable {
    let topSpinner = UIActivityIndicatorView(style: .large)
    let bottomSpinner = UIActivityIndicatorView(style: .large)
    
    @StateObject var viewModel: WKTextViewModel
    let isScrollEnabled: Bool
    let definerResultHandler: ([DefinitionDetails]) -> Void
    let switchSectionHandler: (Bool) -> Void
    let readerViewNavigationMenuToggleHandler: () -> Void
    let updateSynopsisHeightHandler: (CGFloat) -> Void
    
    var webView: WKWebView { viewModel.webView }
    
    init(
        processedContentPublisher: AnyPublisher<ProcessedContent?, Never>,
        isScrollEnabled: Bool,
        definerResultHandler: @escaping ([DefinitionDetails]) -> Void,
        switchSectionHandler: @escaping (Bool) -> Void = { _ in },
        readerViewNavigationMenuToggleHandler: @escaping () -> Void = {},
        updateSynopsisHeightHandler: @escaping (CGFloat) -> Void = { _ in }
    ) {
        self._viewModel = StateObject(
            wrappedValue: WKTextViewModel(processedContentPublisher: processedContentPublisher)
        )
        self.isScrollEnabled = isScrollEnabled
        self.definerResultHandler = definerResultHandler
        self.switchSectionHandler = switchSectionHandler
        self.readerViewNavigationMenuToggleHandler = readerViewNavigationMenuToggleHandler
        self.updateSynopsisHeightHandler = updateSynopsisHeightHandler
    }
    
    init(
        processedContent: ProcessedContent,
        isScrollEnabled: Bool,
        definerResultHandler: @escaping ([DefinitionDetails]) -> Void
    ) {
        self._viewModel = StateObject(
            wrappedValue: WKTextViewModel(processedContent: processedContent)
        )
        self.isScrollEnabled = isScrollEnabled
        self.definerResultHandler = definerResultHandler
        
        self.switchSectionHandler = { _ in }
        self.readerViewNavigationMenuToggleHandler = {}
        self.updateSynopsisHeightHandler = { _ in }
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
            readerViewNavigationMenuToggleHandler: readerViewNavigationMenuToggleHandler,
            startSpinningHandler: startSpinningHandler(offset:),
            updateSynopsisHeightHandler: updateSynopsisHeightHandler
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
    
    class Coordinator: NSObject, WKScriptMessageHandler, UIScrollViewDelegate, UIGestureRecognizerDelegate, WKNavigationDelegate {
        let SWITCH_SECTION_DRAG_OFFSET: CGFloat = 80
        
        let dictionaryFetcher = DictionaryFetcher()
        let webView: WKWebView
        let definerResultHandler: ([DefinitionDetails]) -> Void
        let switchSectionHandler: (Bool) -> Void
        let readerViewNavigationMenuToggleHandler: () -> Void
        let startSpinningHandler: (CGFloat) -> Void
        let updateSynopsisHeightHandler: (CGFloat) -> Void

        var shouldSwitchSection = false
        private var scrollCursorStartScrollPosition: ScrollCursorPosition = .middle

        init(
            webView: WKWebView,
            definerResultHandler: @escaping ([DefinitionDetails]) -> Void,
            switchSectionHandler: @escaping (Bool) -> Void,
            readerViewNavigationMenuToggleHandler: @escaping () -> Void,
            startSpinningHandler: @escaping (CGFloat) -> Void,
            updateSynopsisHeightHandler: @escaping (CGFloat) -> Void
        ) {
            self.webView = webView
            self.definerResultHandler = definerResultHandler
            self.switchSectionHandler = switchSectionHandler
            self.readerViewNavigationMenuToggleHandler = readerViewNavigationMenuToggleHandler
            self.startSpinningHandler = startSpinningHandler
            self.updateSynopsisHeightHandler = updateSynopsisHeightHandler
            super.init()

            webView.navigationDelegate = self

            let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(onDoubleTap(sender:)))
            doubleTapGesture.numberOfTapsRequired = 2
            doubleTapGesture.delegate = self
            webView.addGestureRecognizer(doubleTapGesture)
        }
        
        // MARK: Defining/Highlighting Logic
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
        
        // MARK: Gesture Logic
        /// Toggles the NavBar in ReaderView.
        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
          return true
        }
        
        @objc func onDoubleTap(sender: UITapGestureRecognizer) {
            readerViewNavigationMenuToggleHandler()
        }
        
        // MARK: WKWebView Delegates
        /// Calculates the synopsis height for NovelDetails.
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            self.webView.evaluateJavaScript("document.readyState") { (complete, error) in
                if complete != nil {
                    self.webView.evaluateJavaScript(
                        "document.body.scrollHeight"
                    ) { (height, error) in
                        self.updateSynopsisHeightHandler((height as! CGFloat) / 2)
                    }
                }
            }
        }
              
        // MARK: UIScrollView Delegates
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
            setScrollCursorStartScrollPosition(scrollView: scrollView)
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            if validateScrollCursorStartPositionForSectionChange(scrollView: scrollView) {
                startSpinningHandler(scrollView.contentOffset.y)
            }
        }

        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            startSpinningHandler(0)
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
        
        private func setScrollCursorStartScrollPosition(scrollView: UIScrollView) {
            if scrollView.contentSize.height - scrollView.frame.size.height == 0 {
                scrollCursorStartScrollPosition = .fits
            } else if scrollView.contentOffset.y <= 10 {
                scrollCursorStartScrollPosition = .top
            } else if scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height - 10 {
                scrollCursorStartScrollPosition = .bottom
            } else {
                scrollCursorStartScrollPosition = .middle
            }
        }
        
        private func validateScrollCursorStartPositionForSectionChange(scrollView: UIScrollView) -> Bool {
            //checks if content fits on page
            if scrollCursorStartScrollPosition == ScrollCursorPosition.fits {
                if scrollView.contentOffset.y <= 10 {
                    scrollCursorStartScrollPosition = .top
                } else {
                    scrollCursorStartScrollPosition = .bottom
                }
                return true
            }
            
            // checks if scroll cursor is at top
            if scrollView.contentOffset.y <= 10 {
                return scrollCursorStartScrollPosition == ScrollCursorPosition.top
            }
            
            // checks if scroll cursor is at bottom
            if scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height - 10 {
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
                bottomSpinner.stopAnimating()
                topSpinner.startAnimating()
            } else if offset > webView.scrollView.contentSize.height - webView.frame.size.height {
                bottomSpinner.constraints.last?.constant = offset - (webView.scrollView.contentSize.height - webView.frame.size.height)
                topSpinner.stopAnimating()
                bottomSpinner.startAnimating()
            } else {
                topSpinner.stopAnimating()
                bottomSpinner.stopAnimating()
            }
        }
    }
}

// MARK: Scroll View Delegates
extension WKText {
    
}
