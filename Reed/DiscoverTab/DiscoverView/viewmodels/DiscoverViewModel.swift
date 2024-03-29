//
//  TrendingListSectionViewModel.swift
//  Reed
//
//  Created by Roger Luo on 10/21/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import SwiftUI
import SwiftyNarou

enum DiscoverListCategory: Equatable, Hashable {
    case recent
    case genre(_ value: Genre)
    
    var id: String {
        switch self {
        case .recent: return "Recent"
        case .genre(let genre):
            switch genre {
            case .romance: return "Romance"
            case .fantasy: return "Fantasy"
            case .literature: return "Literature"
            case .scifi: return "Sci-Fi"
            case .other: return "Other"
            case .none: return "Misc."
            }
        }
    }
}

class DiscoverViewModel: ObservableObject {
    @Published var rows: [NovelListRowData] = []
    @Published var category: DiscoverListCategory = .recent
    @Published var isLoading = false
    var startIndex: Int = -FetchNarouConstants.LOAD_INCREMENT.rawValue
    var resultCount: Int = 0 /// prevents making more requests when no more results are available
    let tokenizer = Tokenizer()
    
    init() {
        updateRows()
    }
    
    func updateRows() {
        guard let request = createRequest(for: category) else { return }
        isLoading = true
        Narou.fetchNarouApi(request: request) { data, error in
            if error != nil { return }
            if let data = data {
                self.resultCount = min(
                    data.0,
                    FetchNarouConstants.MAX_RESULT_INDEX.rawValue
                )
                let rows = data.1.map { entry -> NovelListRowData in
                    let title = String(entry.title?.prefix(50) ?? "")
                    let synopsis = String(entry.synopsis?.prefix(200) ?? "")
                    return NovelListRowData(
                        ncode: entry.ncode ?? "",
                        title: title,
                        author: entry.author ?? "",
                        synopsis: synopsis,
                        subgenre: entry.subgenre,
                        titleTokens: self.tokenizer.tokenize(title),
                        synopsisTokens: self.tokenizer.tokenize(synopsis)
                    )
                }
                self.rows.append(contentsOf: rows)
                self.isLoading = false
            }
        }
    }
    
    func createRequest(for category: DiscoverListCategory) -> NarouRequest? {
        let genre: Genre?
        
        switch(category) {
        case .recent:
            genre = nil
        case .genre(let g):
            genre = g
        }
        
        let increment = FetchNarouConstants.LOAD_INCREMENT.rawValue
        if startIndex + increment > resultCount { return nil }
        
        startIndex += increment
        return NarouRequest(
            genre: genre == nil ? nil : [genre!],
            responseFormat: NarouResponseFormat(
                gzipCompressionLevel: 5,
                fileFormat: .JSON,
                fields: [.ncode, .novelTitle, .author, .synopsis, .subgenre],
                limit: increment - 1,
                startIndex: startIndex,
                order: .mostPopularWeek
            )
        )
    }
    
    func updateCategory(newCategory: DiscoverListCategory) {
        category = newCategory
        resetData()
    }
    
    private func resetData() {
        rows = []
        startIndex = -FetchNarouConstants.LOAD_INCREMENT.rawValue
        resultCount = 0
        updateRows()
    }
}
