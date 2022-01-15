//
//  NovelListRowView.swift
//  Reed
//
//  Created by Roger Luo on 1/15/22.
//  Copyright © 2022 Roger Luo. All rights reserved.
//

import SwiftUI

struct NovelListRow: View {
    @State private var isPushedToReader = false
    let data: NovelListRowData
    let definerResultHandler: ([DefinitionDetails]) -> Void
    @Binding var lastSelectedDefinableTextView: DefinableTextView?
    let pushedViewType: PushedViewType

    var body: some View {
        ZStack(alignment: .leading) {
            VStack(alignment: .leading) {
                DefinableText(
                    id: data.ncode + "-title",
                    content: data.title,
                    font: NovelListConstants.TITLE_FONT,
                    lastSelectedDefinableTextView: lastSelectedDefinableTextView,
                    definerResultHandler: definerResultHandler,
                    getTokenHandler: getTitleToken,
                    updateLastSelectedDefinableTextViewHandler: updateLastSelectedDefinableTextViewHandler
                )
                    .frame(
                        width: NovelListConstants.TITLE_WIDTH,
                        height: DefinableTextUtils.calculateContentHeight(
                            content: data.title,
                            font: NovelListConstants.TITLE_FONT,
                            rowWidth: NovelListConstants.TITLE_WIDTH,
                            maxRowCount: NovelListConstants.TITLE_MAX_ROW_COUNT
                        )
                    )
                    .padding(.top, 8)
                
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text(data.author)
                            .font(.caption)
                            .foregroundColor(.gray)
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .padding(.bottom, 8)
                        
                        DefinableText(
                            id: data.ncode + "-synopsis",
                            content: data.synopsis,
                            font: NovelListConstants.SYNOPSIS_FONT,
                            lastSelectedDefinableTextView: lastSelectedDefinableTextView,
                            definerResultHandler: definerResultHandler,
                            getTokenHandler: getSynopsisToken,
                            updateLastSelectedDefinableTextViewHandler: updateLastSelectedDefinableTextViewHandler
                        )
                            .frame(
                                width: NovelListConstants.SYNOPSIS_WIDTH,
                                height: DefinableTextUtils.calculateContentHeight(
                                    content: data.synopsis,
                                    font: NovelListConstants.SYNOPSIS_FONT,
                                    rowWidth: NovelListConstants.SYNOPSIS_WIDTH,
                                    maxRowCount: NovelListConstants.SYNOPSIS_MAX_ROW_COUNT
                                )
                            )
                            .padding(.bottom, 4)
                    }
                    
                    NavigationLinkRightChevron {
                        pushedView()
                        
                    }
                    .padding(.top, 4)
                }
                Divider()
            }
        }
    }
    
    private func pushedView() -> AnyView {
        switch pushedViewType {
        case .NovelDetails:
            return AnyView(NovelDetailsView(ncode: data.ncode))
        case .Reader:
            return AnyView(ReaderView(ncode: data.ncode, novelTitle: data.title))
        }
    }
    
    private func getTitleToken(x: Int) -> Token? {
        return DefinableTextUtils.getToken(x: x, tokens: data.titleTokens)
    }
    
    private func getSynopsisToken(x: Int) -> Token? {
        return DefinableTextUtils.getToken(x: x, tokens: data.synopsisTokens)
    }
    
    func updateLastSelectedDefinableTextViewHandler(definableTextView: DefinableTextView) {
        lastSelectedDefinableTextView = definableTextView
    }
}
