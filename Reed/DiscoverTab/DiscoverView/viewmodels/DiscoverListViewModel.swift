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

class DiscoverListViewModel: ObservableObject {
    @Published var items: [DiscoverListItemViewModel] = []
    var request: NarouRequest!
    
    init(category: DiscoverListCategory) {
        request = createRequest(for: category)
        fetchItems(with: request)
    }
    
    func fetchItems(with category: NarouRequest) {
        Narou.fetchNarouApi(request: request) { data, error in
            if error != nil {
                return
            }
            if let data = data {
                for entry in data.1 {
                    self.items.append(DiscoverListItemViewModel(from: entry))
                }
            }
        }
    }
    
    func createRequest(for category: DiscoverListCategory) -> NarouRequest {
        let genre: Genre?
        
        switch(category) {
        case .recent:
            genre = nil
        case .genre(let g):
            genre = g
        }
        
        return NarouRequest(
            genre: genre == nil ? nil : [genre!],
            responseFormat: NarouResponseFormat(
                gzipCompressionLevel: 5,
                fileFormat: .JSON,
                fields: [.ncode, .novelTitle, .author, .subgenre],
                limit: 10,
                order: .mostPopularWeek
            )
        )
    }
}
