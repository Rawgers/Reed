//
//  LibraryEntryViewModel.swift
//  Reed
//
//  Created by Roger Luo on 9/10/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import SwiftUI
import enum SwiftyNarou.Subgenre

struct LibraryEntryData: Hashable {
    let ncode: String
    let title: String
    let author: String
    let subgenre: Subgenre?
    let titleTokens: [Token]
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(ncode)
    }
    
    static func == (lhs: LibraryEntryData, rhs: LibraryEntryData) -> Bool {
        lhs.ncode == rhs.ncode
    }
}
