//
//  DiscoverListItem.swift
//  Reed
//
//  Created by Roger Luo on 10/23/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import SwiftUI
import WebKit
import struct SwiftyNarou.NarouResponse

struct DiscoverListItem: View {
    @ObservedObject var viewModel: DiscoverListItemViewModel
    @Binding var lastSelectedDefinableTextView: DefinableTextView?
    let definerResultHandler: ([DefinitionDetails]) -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                ZStack {
                    Rectangle().frame(height: 36)
//                    WKText(
//                        processedContent: viewModel.processedTitle,
//                        isScrollEnabled: false,
//                        definerResultHandler: definerResultHandler,
//                        updateLastSelectedWebViewHandler: updateLastSelectedWebView
//                    )
                    DefinableText(content: viewModel.processedTitle.attributedContent, width: 0, height: 0, definerResultHandler: definerResultHandler, getTokenHandler: viewModel.getTitleToken, updateLastSelectedDefinableTextViewHandler: updateLastSelectedDefinableTextViewHandler)
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
