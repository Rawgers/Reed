//
//  TrendingListItemViewModel.swift
//  Reed
//
//  Created by Roger Luo on 10/22/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import SwiftUI
import enum SwiftyNarou.Subgenre
import struct SwiftyNarou.NarouResponse

class TrendingListItemViewModel: ObservableObject {
    let ncode: String
    let title: String
    let author: String
    let subgenre: Subgenre?
    
    init(from data: NarouResponse) {
        ncode = data.ncode ?? ""
        title = data.title ?? ""
        author = data.author ?? ""
        subgenre = data.subgenre
    }
}

extension TrendingListItemViewModel: Hashable, Equatable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(ncode)
    }
    
    static func == (
        lhs: TrendingListItemViewModel,
        rhs: TrendingListItemViewModel
    ) -> Bool {
        return lhs.ncode == rhs.ncode
    }
}
