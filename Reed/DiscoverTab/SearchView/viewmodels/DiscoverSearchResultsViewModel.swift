//
//  DiscoverSearchResultsViewModel.swift
//  Reed
//
//  Created by Roger Luo on 10/28/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import SwiftUI
import SwiftyNarou

enum SearchResultsConstants: Int {
    /* Must be a number large enough to make the screen scroll,
     or else the pagination will fail because the Spacer
     won't be able to move below new entries to "appear" again. */
    case LOAD_INCREMENT = 20
    case MAX_RESULT_INDEX = 2000
}

class DiscoverSearchResultsViewModel: ObservableObject {
    @Published var searchResults: [DiscoverListItemViewModel] = []
    var startIndex: Int = -SearchResultsConstants.LOAD_INCREMENT.rawValue
    var resultCount: Int = 0
    let keyword: String
    
    init(keyword: String) {
        self.keyword = keyword
        updateSearchResults()
    }
    
    func updateSearchResults() {
        guard let request = createRequest() else { return }
        Narou.fetchNarouApi(request: request) { data, error in
            if error != nil { return }
            if let data = data {
                self.resultCount = min(
                    data.0,
                    SearchResultsConstants.MAX_RESULT_INDEX.rawValue
                )
                for entry in data.1 {
                    self.searchResults.append(
                        DiscoverListItemViewModel(from: entry)
                    )
                }
            }
        }
    }
    
    private func createRequest() -> NarouRequest? {
        if keyword == "" { return nil }
        
        let increment = SearchResultsConstants.LOAD_INCREMENT.rawValue
        if startIndex + increment > resultCount { return nil }
        
        startIndex += increment
        return NarouRequest(
            word: keyword,
            responseFormat: NarouResponseFormat(
                gzipCompressionLevel: 5,
                fileFormat: .JSON,
                fields: [.ncode, .novelTitle, .author, .subgenre],
                limit: increment - 1, // offset by one to avoid duplicating last row
                startIndex: startIndex,
                order: .mostPopularWeek
            )
        )
    }
}
