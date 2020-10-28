//
//  DiscoverSearchResultsViewModel.swift
//  Reed
//
//  Created by Roger Luo on 10/28/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import SwiftUI
import SwiftyNarou

class DiscoverSearchResultsViewModel: ObservableObject {
    @Published var searchResults: [DiscoverListItemViewModel] = []
    var request: NarouRequest?
    var keyword: String

    /* Must be a number large enough to make the screen scroll,
     or else the pagination will fail because the Spacer
     won't be able to move below new entries to "appear" again. */
    let LOAD_INCREMENT = 20
    
    init(keyword: String) {
        self.keyword = keyword
        request = createRequest()
        fetchSearchResults(using: request)
    }
    
    func createRequest() -> NarouRequest? {
        if keyword == "" { return nil }
        
        let startIndex = request?.responseFormat?.startIndex ?? -LOAD_INCREMENT
        if startIndex + LOAD_INCREMENT >= 2000 { return nil }
        
        return NarouRequest(
            word: keyword,
            responseFormat: NarouResponseFormat(
                gzipCompressionLevel: 5,
                fileFormat: .JSON,
                fields: [.ncode, .novelTitle, .author, .subgenre],
                limit: LOAD_INCREMENT,
                startIndex: startIndex + LOAD_INCREMENT,
                order: .mostPopularWeek
            )
        )
    }
    
    func fetchSearchResults(using request: NarouRequest?) {
        guard let request = request else { return }
        Narou.fetchNarouApi(request: request) { data, error in
            if error != nil { return }
            if let data = data {
                for entry in data {
                    self.searchResults.append(DiscoverListItemViewModel(from: entry))
                }
            }
        }
    }
}
