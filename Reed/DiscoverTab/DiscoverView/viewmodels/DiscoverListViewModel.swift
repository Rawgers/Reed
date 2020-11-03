//
//  TrendingListSectionViewModel.swift
//  Reed
//
//  Created by Roger Luo on 10/21/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import SwiftUI
import SwiftyNarou

enum DiscoverListCategory: Equatable {
    case recent
    case genre(_ value: Genre)
    
    var id: String {
        switch self {
        case .recent: return "RE"
        case .genre(let genre):
            switch genre {
            case .romance: return "RO"
            case .fantasy: return "FY"
            case .literature: return "LT"
            case .scifi: return "SF"
            case .other: return "OT"
            case .none: return "NO"
            }
        }
    }
}

class DiscoverViewModel: ObservableObject {
    @Published var rows: [DiscoverListItemViewModel] = []
    @Published var category: DiscoverListCategory = .recent
    var startIndex: Int = -FetchNarouConstants.LOAD_INCREMENT.rawValue
    var resultCount: Int = 0
    
    init() {
        updateRows()
    }
    
    func updateRows() {
        print(startIndex)
        guard let request = createRequest(for: category) else { return }
        Narou.fetchNarouApi(request: request) { data, error in
            if error != nil { return }
            if let data = data {
                self.resultCount = min(
                    data.0,
                    FetchNarouConstants.MAX_RESULT_INDEX.rawValue
                )
                for entry in data.1 {
                    self.rows.append(DiscoverListItemViewModel(from: entry))
                }
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
                fields: [.ncode, .novelTitle, .author, .subgenre],
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
