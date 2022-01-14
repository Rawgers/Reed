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
        HStack(alignment: .center){
            VStack(alignment: .leading, spacing: 0) {
                DefinableText(
                    id: viewModel.ncode + "-title",
                    content: viewModel.processedTitle.attributedContent,
                    font: DiscoverListItemConstants.TITLE_FONT,
                    lastSelectedDefinableTextView: lastSelectedDefinableTextView,
                    definerResultHandler: definerResultHandler,
                    getTokenHandler: viewModel.getTitleToken,
                    updateLastSelectedDefinableTextViewHandler: updateLastSelectedDefinableTextViewHandler
                )
                    .frame(
                        width: DiscoverListItemConstants.TITLE_WIDTH,
                        height: viewModel.titleHeight
                    )
                    .padding(.top, 8)
                
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text(viewModel.author + "｜" + viewModel.subgenre!.nameJp
                        )
                            .frame(width: DiscoverListItemConstants.SYNOPSIS_WIDTH, alignment: .leading)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .padding(.bottom, 4)
                        
                        DefinableText(
                            id: viewModel.ncode + "-synopsis",
                            content: viewModel.processedSynopsis.attributedContent,
                            font: DiscoverListItemConstants.SYNOPSIS_FONT,
                            lastSelectedDefinableTextView: lastSelectedDefinableTextView,
                            definerResultHandler: definerResultHandler,
                            getTokenHandler: viewModel.getSynopsisToken,
                            updateLastSelectedDefinableTextViewHandler: updateLastSelectedDefinableTextViewHandler
                        )
                            .frame(
                                width: DiscoverListItemConstants.SYNOPSIS_WIDTH,
                                height: viewModel.synopsisHeight
                            )
                            .padding(.bottom, 4)
                    }
                    
                    NavigationLink(
                        destination: NavigationLazyView(
                            NovelDetailsView(ncode: viewModel.ncode)
                        )
                    ) {
                        Image(systemName: "chevron.right")
                            .frame(width: 32, height: 48)
                            .imageScale(.medium)
                            .foregroundColor(Color(UIColor.systemBlue))
                            .background(Color(UIColor.secondarySystemBackground))
                            .cornerRadius(8)
                    }
                    .padding(.top, 4)
                }
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
