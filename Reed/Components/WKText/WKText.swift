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
        Coordinator()
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
        func userContentController(
            _ userContentController: WKUserContentController,
            didReceive message: WKScriptMessage
        ) {
            guard let dict = message.body as? [String : AnyObject] else { return }
            print(dict)
        }
    }
}
