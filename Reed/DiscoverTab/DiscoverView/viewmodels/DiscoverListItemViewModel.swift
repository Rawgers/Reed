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

enum DiscoverListItemConstants {
    static let TITLE_WIDTH: CGFloat = UIScreen.main.bounds.width - 24
    static let SYNOPSIS_WIDTH: CGFloat = UIScreen.main.bounds.width - 72
    static let TITLE_FONT = UIFont.systemFont(ofSize: 20, weight: .bold)
    static let TITLE_MAX_ROW_COUNT: CGFloat = 2
    static let SYNOPSIS_FONT = UIFont.systemFont(ofSize: 13)
    static let SYNOPSIS_MAX_ROW_COUNT: CGFloat = 3
}

class DiscoverListItemViewModel: ObservableObject {
    static let heightComputer = DefinableTextView()
    
    let ncode: String
    let title: String
    let author: String
    let synopsis: String
    let subgenre: Subgenre?
    
    let processedTitle: ProcessedContent
    let processedSynopsis: ProcessedContent
    @Published var titleHeight: CGFloat = 0
    @Published var synopsisHeight: CGFloat = 0

    init(from data: NarouResponse) {
        ncode = data.ncode ?? ""
        title = data.title ?? ""
        author = data.author ?? ""
        synopsis = data.synopsis ?? ""
        subgenre = data.subgenre
        
        processedTitle = ProcessedContent(content: title, withFurigana: false)
        processedSynopsis = ProcessedContent(content: synopsis, withFurigana: false)
        
        self.titleHeight = DiscoverListItemViewModel.heightComputer.calculateRowHeight(
            content: self.processedTitle.attributedContent,
            font: DiscoverListItemConstants.TITLE_FONT,
            rowWidth: DiscoverListItemConstants.TITLE_WIDTH,
            maxRowCount:  DiscoverListItemConstants.TITLE_MAX_ROW_COUNT
        )
        self.synopsisHeight = DiscoverListItemViewModel.heightComputer.calculateRowHeight(
            content: self.processedSynopsis.attributedContent,
            font: DiscoverListItemConstants.SYNOPSIS_FONT,
            rowWidth: DiscoverListItemConstants.SYNOPSIS_WIDTH,
            maxRowCount:  DiscoverListItemConstants.SYNOPSIS_MAX_ROW_COUNT
        )
    }
    
    func getTitleToken(x: Int) -> Token? {
        return getToken(x: x, tokens: processedTitle.tokens)
    }
    
    func getSynopsisToken(x: Int) -> Token? {
        return getToken(x: x, tokens: processedSynopsis.tokens)
    }
    
    // Used in DefinableTextView to highlight tapped token.
    private func getToken(x: Int, tokens: [Token]) -> Token? {
        var i = 0
        var j = tokens.endIndex
        while j >= i {
            let mid = i + (j - i) / 2
            if tokens[mid].range.lowerBound <= x
                && tokens[mid].range.upperBound > x {
                return tokens[mid]
            } else if tokens[mid].range.lowerBound > x {
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
