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
    private static let INITIAL_ROW_HEIGHT: CGFloat = 29
    
    @ObservedObject var viewModel: DiscoverListItemViewModel
    @Binding var lastSelectedDefinableTextView: DefinableTextView?
    @State private var rowHeight: CGFloat = INITIAL_ROW_HEIGHT
    let definerResultHandler: ([DefinitionDetails]) -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                ZStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(height: rowHeight)
                    DefinableText(
                        id: viewModel.ncode + "-title",
                        lastSelectedDefinableTextView: lastSelectedDefinableTextView,
                        content: viewModel.processedTitle.attributedContent,
                        width: UIScreen.main.bounds.width,
                        height: 100,
                        definerResultHandler: definerResultHandler,
                        getTokenHandler: viewModel.getTitleToken,
                        updateLastSelectedDefinableTextViewHandler: updateLastSelectedDefinableTextViewHandler,
                        updateRowHeight: updateRowHeight
                    )
                        .padding(.top, 8)
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
    
    func updateRowHeight() {
        rowHeight = DiscoverListItem.INITIAL_ROW_HEIGHT + 20
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
