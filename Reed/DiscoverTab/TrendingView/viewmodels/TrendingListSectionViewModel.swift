//
//  TrendingListSectionViewModel.swift
//  Reed
//
//  Created by Roger Luo on 10/21/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import SwiftUI
import SwiftyNarou

class TrendingListSectionViewModel: ObservableObject {
    @Published var items: [DiscoverListItemViewModel] = []
    let header: String
    var request: NarouRequest!
    
    init(category: TrendingListSectionCategory) {
        switch(category) {
        case .recent:
            header = String(describing: category)
        case .genre(let genre):
            header = String(describing: genre)
        }
        
        request = createRequest(for: category)
        fetchItems(with: request)
    }
    
    func fetchItems(with category: NarouRequest) {
        Narou.fetchNarouApi(request: request) { data, error in
            if error != nil {
                return
            }
            if let data = data {
                for entry in data {
                    self.items.append(DiscoverListItemViewModel(from: entry))
                }
            }
        }
    }
    
    func createRequest(for category: TrendingListSectionCategory) -> NarouRequest {
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

extension TrendingListSectionViewModel: Hashable, Equatable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(header)
    }
    
    static func == (
        lhs: TrendingListSectionViewModel,
        rhs: TrendingListSectionViewModel
    ) -> Bool {
        return lhs.header == rhs.header
    }
}