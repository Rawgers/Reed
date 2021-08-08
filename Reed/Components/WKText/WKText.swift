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
    
    init(processedContentPublisher: AnyPublisher<ProcessedContent?, Never>) {
        self._viewModel = StateObject(wrappedValue: WKTextViewModel(processedContentPublisher: processedContentPublisher))
    }
    
    func makeUIView(context: UIViewRepresentableContext<WKText>) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
//        print(viewModel.contentInHtml)
        uiView.loadHTMLString(viewModel.contentInHtml, baseURL: nil)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject {}
}
