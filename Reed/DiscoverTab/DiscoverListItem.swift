//
//  DiscoverListItem.swift
//  Reed
//
//  Created by Roger Luo on 10/23/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import SwiftUI
import struct SwiftyNarou.NarouResponse

struct DiscoverListItem: View {
    @ObservedObject var viewModel: DiscoverListItemViewModel
    
    var body: some View {
        HStack {
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
            Spacer()
            NavigationLink(
                destination: NavigationLazyView(
                    NovelDetailsView(ncode: viewModel.ncode)
                )
            ) {
                Image(systemName: "chevron.right")
                    .imageScale(.small)
                    .foregroundColor(Color(.systemGray5))
            }
        }
        Divider()
    }
}

struct DiscoverListItem_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverListItem(
            viewModel: DiscoverListItemViewModel(
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
