//
//  NovelDetailsViewModel.swift
//  Reed
//
//  Created by Roger Luo on 10/29/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import SwiftUI
import SwiftyNarou

class NovelDetailsViewModel: ObservableObject {
    @Published var bookData: NarouResponse = NarouResponse()
    
    init(ncode: String) {
        fetchNovelDetails(for: ncode)
    }
    
    func fetchNovelDetails(for ncode: String) {
        let request = NarouRequest(
            ncode: [ncode],
            responseFormat: NarouResponseFormat(
                gzipCompressionLevel: 5,
                fileFormat: .JSON
            )
        )
        
        Narou.fetchNarouApi(request: request) { data, error in
            if error != nil { return }
            guard let data = data else { return }
            self.bookData = data.1[0]
        }
    }
}

// Unwrap and postprocess NarouResponse optionals for readability
extension NovelDetailsViewModel {
    var title: String {
        bookData.title ?? ""
    }
    
    var synopsis: String {
        bookData.synopsis?.trimmingCharacters(in: ["\n"]) ?? ""
    }
}
