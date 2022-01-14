//
//  WKTextViewModel..swift
//  Reed
//
//  Created by Roger Luo on 8/7/21.
//  Copyright © 2021 Roger Luo. All rights reserved.
//

import Combine
import WebKit

class WKTextViewModel: ObservableObject {
    let id = UUID()
    let webView = WKWebView()
    var processedContentCancellable: AnyCancellable?
    
    init(processedContentPublisher: AnyPublisher<ProcessedContent?, Never>) {
        self.processedContentCancellable = processedContentPublisher.sink { [weak self] processedContent in
            guard let self = self else { return }
            guard let processedContent = processedContent else { return }
            self.webView.loadHTMLString(processedContent.annotatedContent, baseURL: nil)
        }
        webView.underPageBackgroundColor = .clear
        webView.backgroundColor = .clear
        webView.isOpaque = false
    }
    
    init(processedContent: ProcessedContent) {
        self.webView.loadHTMLString(processedContent.annotatedContent, baseURL: nil)
    }
    
    // For mocking
    init() {}
    
    deinit {
        self.processedContentCancellable?.cancel()
    }
}

extension WKTextViewModel: Equatable {
    static func == (lhs: WKTextViewModel, rhs: WKTextViewModel) -> Bool {
        lhs.id == rhs.id
    }
}
