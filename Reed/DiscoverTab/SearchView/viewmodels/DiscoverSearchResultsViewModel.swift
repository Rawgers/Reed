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
    let keyword: String
    var start: Int = 0
    
    init(keyword: String) {
        self.keyword = keyword
        createRequest(with: keyword)
        fetchSearchResults(using: request)
    }
    
    func createRequest(with keyword: String) {
        request = NarouRequest(
            word: keyword,
            responseFormat: NarouResponseFormat(
                gzipCompressionLevel: 5,
                fileFormat: .JSON,
                fields: [.ncode, .novelTitle, .author, .subgenre],
                start: start,
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
