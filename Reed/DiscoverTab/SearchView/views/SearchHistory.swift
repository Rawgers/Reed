//
//  SearchHistory.swift
//  Reed
//
//  Created by Roger Luo on 10/24/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import SwiftUI

struct SearchHistory: View {
    let searchHistory: [SearchHistoryEntry]
    let onTapRow: (String) -> Void
    
    var body: some View {
        List(searchHistory.reversed(), id: \.self.id) { entry in
            Button(entry.text) {
                onTapRow(entry.text)
            }
            .lineLimit(1)
        }
        .listStyle(PlainListStyle())
    }
}

struct SearchHistory_Previews: PreviewProvider {
    static var previews: some View {
        let searchHistory = [
            SearchHistoryEntry(text: "最強"),
            SearchHistoryEntry(text: "無職転生"),
            SearchHistoryEntry(text: "冒険者")
        ]
        SearchHistory(searchHistory: searchHistory) { word in }
    }
}
