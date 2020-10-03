//
//  LibraryEntryViewModel.swift
//  Reed
//
//  Created by Roger Luo on 9/10/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import SwiftUI


class LibraryEntryViewModel: ObservableObject {
    let title: String
    let author: String
    
    init(entryData: LibraryEntry) {
        title = entryData.title ?? "unknown"
        author = entryData.author ?? "unknown"
    }
}

extension LibraryEntryViewModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(author)
    }
}

extension LibraryEntryViewModel: Equatable {
    static func == (lhs: LibraryEntryViewModel, rhs: LibraryEntryViewModel) -> Bool {
        return lhs.title == rhs.title && lhs.author == rhs.author
    }
}
