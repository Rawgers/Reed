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
        contentController.add(
            context.coordinator,
            name: "handleTapWord"
        )
        
        if let url = Bundle.main.url(
            forResource: "TextAugmentations",
            withExtension: "js"
        ) {
            do {
                let js = try String(contentsOf: url)
                let script = WKUserScript(source: js, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
                contentController.addUserScript(script)
            } catch {
                print("Could not find Javascript.")
            }
        }
        return webView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        uiView.loadHTMLString(viewModel.contentInHtml, baseURL: nil)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
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
