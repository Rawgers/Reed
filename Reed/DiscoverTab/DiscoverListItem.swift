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
    @Binding var lastSelectedDefinableTextView: DefinableTextView?
    let definerResultHandler: ([DefinitionDetails]) -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                ZStack {
                    DefinableText(
                        id: viewModel.ncode + "-title",
                        lastSelectedDefinableTextView: lastSelectedDefinableTextView,
                        content: viewModel.processedTitle.attributedContent,
                        definerResultHandler: definerResultHandler,
                        getTokenHandler: viewModel.getTitleToken,
                        updateLastSelectedDefinableTextViewHandler: updateLastSelectedDefinableTextViewHandler
                    ).frame(
                        width: UIScreen.main.bounds.width - 16,
                        height: viewModel.rowHeight
                    )
                }
                
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
    
    func updateLastSelectedDefinableTextViewHandler(definableTextView: DefinableTextView) {
        lastSelectedDefinableTextView = definableTextView
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
            ),
            lastSelectedDefinableTextView: .constant(DefinableTextView(coder: NSCoder())),
            definerResultHandler: { _ in }
        )
    }
}
