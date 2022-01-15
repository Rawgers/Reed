//
//  NovelListRowData.swift
//  Reed
//
//  Created by Roger Luo on 1/15/22.
//  Copyright © 2022 Roger Luo. All rights reserved.
//

import SwiftUI
import enum SwiftyNarou.Subgenre

struct NovelListRowData: Hashable {
    let ncode: String
    let title: String
    let author: String
    let synopsis: String
    let subgenre: Subgenre?
    let titleTokens: [Token]
    let synopsisTokens: [Token]
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(ncode)
    }
    
    static func == (lhs: NovelListRowData, rhs: NovelListRowData) -> Bool {
        lhs.ncode == rhs.ncode
    }
}
