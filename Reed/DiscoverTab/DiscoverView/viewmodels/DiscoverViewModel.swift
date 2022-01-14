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
    @Published var rows: [DiscoverListItemViewModel] = []
    @Published var category: DiscoverListCategory = .recent
    var startIndex: Int = -FetchNarouConstants.LOAD_INCREMENT.rawValue
    var resultCount: Int = 0 /// prevents making more requests when no more results are available
    
    init() {
        updateRows()
    }
    
    func updateRows() {
        guard let request = createRequest(for: category) else { return }
        Narou.fetchNarouApi(request: request) { data, error in
            if error != nil { return }
            if let data = data {
                self.resultCount = min(
                    data.0,
                    FetchNarouConstants.MAX_RESULT_INDEX.rawValue
                )
                var rows = [DiscoverListItemViewModel]()
                for entry in data.1 {
                    rows.append(DiscoverListItemViewModel(from: entry))
                }
                self.rows.append(contentsOf: rows)
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
                fields: [.ncode, .novelTitle, .author, .subgenre, .synopsis],
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
