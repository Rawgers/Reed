//
//  SearchHistory.swift
//  Reed
//
//  Created by Roger Luo on 10/24/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import SwiftUI

struct SearchHistory: View {
    let searchHistory: [String]
    let onTapRow: (String) -> Void
    
    var body: some View {
        List(searchHistory.reversed(), id: \.self) { text in
            Button(text) {
                onTapRow(text)
            }
            .lineLimit(1)
        }
        .listStyle(PlainListStyle())
    }
}

struct SearchHistory_Previews: PreviewProvider {
    static var previews: some View {
        let searchHistory = [
            "最強",
            "無職転生",
            "冒険者"
        ]
        SearchHistory(searchHistory: searchHistory) { word in }
    }
}
