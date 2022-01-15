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
    @Published var searchResults: [DiscoverListItemData] = []
    var startIndex: Int = -FetchNarouConstants.LOAD_INCREMENT.rawValue
    var resultCount: Int = 0
    let keyword: String
    let tokenizer = Tokenizer()

    init(searchText keyword: String) {
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
                    FetchNarouConstants.MAX_RESULT_INDEX.rawValue
                )
                let rows = data.1.map { entry -> DiscoverListItemData in
                    let title = String(entry.title?.prefix(50) ?? "")
                    let synopsis = String(entry.synopsis?.prefix(200) ?? "")
                    return DiscoverListItemData(
                        ncode: entry.ncode ?? "",
                        author: entry.author ?? "",
                        title: title,
                        synopsis: synopsis,
                        titleTokens: self.tokenizer.tokenize(title),
                        synopsisTokens: self.tokenizer.tokenize(synopsis),
                        subgenre: entry.subgenre
                    )
                }
                self.searchResults.append(contentsOf: rows)
            }
        }
    }
    
    private func createRequest() -> NarouRequest? {
        if keyword == "" { return nil }
        
        let increment = FetchNarouConstants.LOAD_INCREMENT.rawValue
        if startIndex + increment > resultCount { return nil }
        
        startIndex += increment
        return NarouRequest(
            word: keyword,
            responseFormat: NarouResponseFormat(
                gzipCompressionLevel: 5,
                fileFormat: .JSON,
                fields: [.ncode, .novelTitle, .author, .synopsis, .subgenre],
                limit: increment - 1, // offset by one to avoid duplicating last row
                startIndex: startIndex,
                order: .mostPopularWeek
            )
        )
    }
}
