//
//  TrendingListItem.swift
//  Reed
//
//  Created by Roger Luo on 10/23/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import SwiftUI
import struct SwiftyNarou.NarouResponse

struct TrendingListItem: View {
    @ObservedObject var viewModel: TrendingListItemViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(viewModel.title)
                .font(.headline)
                .lineLimit(2)
                .truncationMode(.tail)
            Text(viewModel.author)
                .font(.caption)
                .foregroundColor(.gray)
                .lineLimit(1)
                .truncationMode(.tail)
        }
    }
}

struct TrendingListSectionItem_Previews: PreviewProvider {
    static var previews: some View {
        TrendingListItem(
            viewModel: TrendingListItemViewModel(
                from: NarouResponse(
                    title: "無職転生　- 異世界行ったら本気だす -",
                    ncode: "n9669bk",
                    author: "理不尽な孫の手",
                    subgenre: .fantasyHigh
                )
            )
        )
    }
}
