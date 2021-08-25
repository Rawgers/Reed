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

fileprivate enum WKTextError: Error {
    case scriptError(String)
}

struct WKText: UIViewRepresentable {
    @EnvironmentObject var definerResults: DefinerResults
    @StateObject var viewModel: WKTextViewModel
    let webView = WKWebView()
    let sectionSwitchHandler: (Bool) -> Void
    
    init(
        processedContentPublisher: AnyPublisher<ProcessedContent?, Never>,
        sectionSwitchHandler: @escaping (Bool) -> Void
    ) {
        self._viewModel = StateObject(
            wrappedValue: WKTextViewModel(processedContentPublisher: processedContentPublisher)
        )
        self.sectionSwitchHandler = sectionSwitchHandler
    }
    
    func makeUIView(context: UIViewRepresentableContext<WKText>) -> WKWebView {
        let contentController = webView.configuration.userContentController
        contentController.add(context.coordinator, name: "handleTapWord")
        webView.scrollView.delegate = context.coordinator

        do {
            let textAugmentations = try readFile(name: "TextAugmentations", ext: "js")
            let textAugmentationsScript = WKUserScript(
                source: textAugmentations,
                injectionTime: .atDocumentEnd,
                forMainFrameOnly: false
            )
            contentController.addUserScript(textAugmentationsScript)
        } catch {
            print(error.localizedDescription)
        }
        
        return webView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        uiView.loadHTMLString(viewModel.contentInHtml, baseURL: nil)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(
            webView: webView,
            definerResultHandler: definerResults.updateEntries,
            sectionSwitchHandler: sectionSwitchHandler
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
        let dictionaryFetcher = DictionaryFetcher()
        let webView: WKWebView
        let definerResultHandler: ([DefinitionDetails]) -> Void
        let sectionSwitchHandler: (Bool) -> Void
        var canSwitch = false

        init(
            webView: WKWebView,
            definerResultHandler: @escaping ([DefinitionDetails]) -> Void,
            sectionSwitchHandler: @escaping (Bool) -> Void
        ) {
            self.webView = webView
            self.definerResultHandler = definerResultHandler
            self.sectionSwitchHandler = sectionSwitchHandler
        }
        
        func userContentController(
            _ userContentController: WKUserContentController,
            didReceive message: WKScriptMessage
        ) {
            guard let dict = message.body as? [String : AnyObject] else { return }
            defineSelection(from: dict["word"] as! String)
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
            // Scrolling acceleration didn't continue after the finger was lifted
            print(scrollView.contentOffset.y)
            if scrollView.contentOffset.y < -200
                || scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.frame.size.height + 200 {
                if !decelerate {
                    executeActionAtTheEnd(of: scrollView)
                } else {
                    canSwitch = true
                }
            } else {
                canSwitch = false
            }
        }

        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            if canSwitch {
                executeActionAtTheEnd(of: scrollView)
            }
        }

        private func executeActionAtTheEnd(of scrollView: UIScrollView) {
            print(scrollView.contentOffset.y)
            if scrollView.contentOffset.y == 0 {
                sectionSwitchHandler(false)
            } else if scrollView.contentOffset.y + 1 >= (scrollView.contentSize.height - scrollView.frame.size.height) {
                sectionSwitchHandler(true)
            }
        }
    }
}
