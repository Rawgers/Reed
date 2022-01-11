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

class DiscoverListItemViewModel: ObservableObject {
    let ncode: String
    let title: String
    let author: String
    let subgenre: Subgenre?
    
    let processedTitle: ProcessedContent
    
    init(from data: NarouResponse) {
        ncode = data.ncode ?? ""
        title = data.title ?? ""
        author = data.author ?? ""
        subgenre = data.subgenre
        processedTitle = ProcessedContent(content: title, withFurigana: false)
    }
    
    // Used in DefinableTextView to highlight tapped token.
    func getTitleToken(x: Int) -> Token? {
        var i = 0
        var j = processedTitle.tokens.endIndex
        while j >= i {
            let mid = i + (j - i) / 2
            if processedTitle.tokens[mid].range.lowerBound <= x && processedTitle.tokens[mid].range.upperBound > x {
                return processedTitle.tokens[mid]
            } else if processedTitle.tokens[mid].range.lowerBound > x {
                j = mid - 1
            } else {
                i = mid + 1
            }
        }
        return nil
    }
}

extension DiscoverListItemViewModel: Hashable, Equatable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(ncode)
    }
    
    static func == (
        lhs: DiscoverListItemViewModel,
        rhs: DiscoverListItemViewModel
    ) -> Bool {
        return lhs.ncode == rhs.ncode
    }
}
