//
//  WKTextViewModel..swift
//  Reed
//
//  Created by Roger Luo on 8/7/21.
//  Copyright © 2021 Roger Luo. All rights reserved.
//

import Combine

class WKTextViewModel: ObservableObject {
    @Published var contentInHtml: String = ""
    var processedContentCancellable: AnyCancellable?
    
    init(processedContentPublisher: AnyPublisher<ProcessedContent?, Never>) {
        self.processedContentCancellable = processedContentPublisher.sink { [weak self] processedContent in
            guard let self = self else { return }
            guard let processedContent = processedContent else { return }
            
            self.contentInHtml = processedContent.annotatedContent
        }
    }
    
    deinit {
        self.processedContentCancellable?.cancel()
    }
}
