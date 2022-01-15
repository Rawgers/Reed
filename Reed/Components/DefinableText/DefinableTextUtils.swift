//
//  DefinableTextUtils.swift
//  Reed
//
//  Created by Roger Luo on 1/14/22.
//  Copyright © 2022 Roger Luo. All rights reserved.
//

import UIKit

struct DefinableTextUtils {
    static let heightCalculator = DefinableTextView()
    
    static func calculateContentHeight(content: String) -> CGFloat {
        heightCalculator.calculateRowHeight(
            content: content,
            font: DiscoverListItemConstants.TITLE_FONT,
            rowWidth: DiscoverListItemConstants.TITLE_WIDTH,
            maxRowCount: DiscoverListItemConstants.TITLE_MAX_ROW_COUNT
        )
    }
    
    static func getToken(x: Int, tokens: [Token]) -> Token? {
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
