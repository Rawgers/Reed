//
//  TrendingListViewModel.swift
//  Reed
//
//  Created by Roger Luo on 10/23/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import SwiftyNarou

enum TrendingListSectionCategory: Equatable {
    case recent
    case genre(_ value: Genre)
}

class TrendingListViewModel: ObservableObject {
    @Published var sections: [TrendingListSectionViewModel]
    
    init() {
        var sections = [TrendingListSectionViewModel]()
        sections.append(TrendingListSectionViewModel(category: .recent))
        for genre in Genre.allCases {
            sections.append(TrendingListSectionViewModel(category: .genre(genre)))
        }
        self.sections = sections
    }
}
