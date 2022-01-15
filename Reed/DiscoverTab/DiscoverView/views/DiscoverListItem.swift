//
//  DiscoverListItem.swift
//  Reed
//
//  Created by Roger Luo on 10/23/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import SwiftUI
import struct SwiftyNarou.NarouResponse

enum DiscoverListItemConstants {
    static let TITLE_WIDTH: CGFloat = UIScreen.main.bounds.width - 24
    static let SYNOPSIS_WIDTH: CGFloat = UIScreen.main.bounds.width - 72
    static let TITLE_FONT = UIFont.systemFont(ofSize: 20, weight: .bold)
    static let TITLE_MAX_ROW_COUNT: CGFloat = 2
    static let SYNOPSIS_FONT = UIFont.systemFont(ofSize: 13)
    static let SYNOPSIS_MAX_ROW_COUNT: CGFloat = 3
}

struct DiscoverListItem: View {
    let heightCalculator = DefinableTextView()
    let data: DiscoverListItemData
    @Binding var lastSelectedDefinableTextView: DefinableTextView?
    let definerResultHandler: ([DefinitionDetails]) -> Void
    
    var body: some View {
        HStack(alignment: .center){
            VStack(alignment: .leading, spacing: 0) {
                DefinableText(
                    id: data.ncode + "-title",
                    content: data.title,
                    font: DiscoverListItemConstants.TITLE_FONT,
                    lastSelectedDefinableTextView: lastSelectedDefinableTextView,
                    definerResultHandler: definerResultHandler,
                    getTokenHandler: getTitleToken,
                    updateLastSelectedDefinableTextViewHandler: updateLastSelectedDefinableTextViewHandler
                )
                    .frame(
                        width: DiscoverListItemConstants.TITLE_WIDTH,
                        height: calculateTitleHeight()
                    )
                    .padding(.top, 8)
                
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text(data.author + "｜" + data.subgenre!.nameJp
                        )
                            .frame(width: DiscoverListItemConstants.SYNOPSIS_WIDTH, alignment: .leading)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .padding(.bottom, 4)
                        
                        DefinableText(
                            id: data.ncode + "-synopsis",
                            content: data.synopsis,
                            font: DiscoverListItemConstants.SYNOPSIS_FONT,
                            lastSelectedDefinableTextView: lastSelectedDefinableTextView,
                            definerResultHandler: definerResultHandler,
                            getTokenHandler: getSynopsisToken,
                            updateLastSelectedDefinableTextViewHandler: updateLastSelectedDefinableTextViewHandler
                        )
                            .frame(
                                width: DiscoverListItemConstants.SYNOPSIS_WIDTH,
                                height: calculateSynopsisHeight()
                            )
                            .padding(.bottom, 4)
                    }
                    
                    NavigationLink(
                        destination: NavigationLazyView(
                            NovelDetailsView(ncode: data.ncode)
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
    
    private func calculateTitleHeight() -> CGFloat {
        return heightCalculator.calculateRowHeight(
            content: data.title,
            font: DiscoverListItemConstants.TITLE_FONT,
            rowWidth: DiscoverListItemConstants.TITLE_WIDTH,
            maxRowCount: DiscoverListItemConstants.TITLE_MAX_ROW_COUNT
        )
    }
    
    private func calculateSynopsisHeight() -> CGFloat {
        return heightCalculator.calculateRowHeight(
            content: data.synopsis,
            font: DiscoverListItemConstants.SYNOPSIS_FONT,
            rowWidth: DiscoverListItemConstants.SYNOPSIS_WIDTH,
            maxRowCount: DiscoverListItemConstants.SYNOPSIS_MAX_ROW_COUNT
        )
    }
    
    private func getTitleToken(x: Int) -> Token? {
        return getToken(x: x, tokens: data.titleTokens)
    }
    
    private func getSynopsisToken(x: Int) -> Token? {
        return getToken(x: x, tokens: data.synopsisTokens)
    }
    
    private func getToken(x: Int, tokens: [Token]) -> Token? {
        var i = 0
        var j = tokens.endIndex
        while j >= i {
            let mid = i + (j - i) / 2
            if tokens[mid].range.lowerBound <= x
                && tokens[mid].range.upperBound > x {
                return tokens[mid]
            } else if tokens[mid].range.lowerBound > x {
                j = mid - 1
            } else {
                i = mid + 1
            }
        }
        return nil
    }
    
    func updateLastSelectedDefinableTextViewHandler(definableTextView: DefinableTextView) {
        lastSelectedDefinableTextView = definableTextView
    }
}

//struct DiscoverListItem_Previews: PreviewProvider {
//    static var previews: some View {
//        DiscoverListItem(
//            viewModel: DiscoverListItemViewModel(
//                from: NarouResponse(
//                    title: "無職転生　- 異世界行ったら本気だす -",
//                    ncode: "n9669bk",
//                    author: "理不尽な孫の手",
//                    subgenre: .fantasyHigh
//                )
//            ),
//            lastSelectedDefinableTextView: .constant(DefinableTextView(coder: NSCoder())),
//            definerResultHandler: { _ in }
//        )
//    }
//}
