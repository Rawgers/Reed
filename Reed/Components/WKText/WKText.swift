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
    
    init(processedContentPublisher: AnyPublisher<ProcessedContent?, Never>) {
        self._viewModel = StateObject(
            wrappedValue: WKTextViewModel(processedContentPublisher: processedContentPublisher)
        )
    }
    
    func makeUIView(context: UIViewRepresentableContext<WKText>) -> WKWebView {
        let contentController = webView.configuration.userContentController
        contentController.add(context.coordinator, name: "handleTapWord")
        
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
        Coordinator(definerResultHandler: definerResults.updateEntries)
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
    
    class Coordinator: NSObject, WKScriptMessageHandler {
        let dictionaryFetcher = DictionaryFetcher()
        let definerResultHandler: ([DefinitionDetails]) -> Void
        
        init(definerResultHandler: @escaping ([DefinitionDetails]) -> Void) {
            self.definerResultHandler = definerResultHandler
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
    }
}
