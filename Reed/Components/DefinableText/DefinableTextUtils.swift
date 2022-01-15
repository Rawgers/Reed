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
    
    static func calculateContentHeight(
        content: String,
        font: UIFont,
        rowWidth: CGFloat,
        maxRowCount: CGFloat
    ) -> CGFloat {
        heightCalculator.calculateRowHeight(
            content: content,
            font: font,
            rowWidth: rowWidth,
            maxRowCount: maxRowCount
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
