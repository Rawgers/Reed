//
//  LibraryViewController.swift
//  Reed
//
//  Created by Roger Luo on 9/9/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import SwiftUI

enum LibraryEntryConstants {
    static let TITLE_WIDTH: CGFloat = UIScreen.main.bounds.width - 24
    static let TITLE_FONT = UIFont.systemFont(ofSize: 20, weight: .bold)
    static let TITLE_MAX_ROW_COUNT: CGFloat = 2
}

struct LibraryEntryView: View {
    @State var isPushedToReader = false
    @Binding var lastSelectedDefinableTextView: DefinableTextView?
    let definerResultHandler: ([DefinitionDetails]) -> Void
    let data: LibraryEntryData

    var body: some View {
        ZStack(alignment: .leading) {
            VStack(alignment: .leading) {
                DefinableText(
                    id: data.ncode + "-title",
                    content: data.title,
                    font: LibraryEntryConstants.TITLE_FONT,
                    lastSelectedDefinableTextView: lastSelectedDefinableTextView,
                    definerResultHandler: definerResultHandler,
                    getTokenHandler: getTitleToken,
                    updateLastSelectedDefinableTextViewHandler: updateLastSelectedDefinableTextViewHandler
                )
                    .frame(
                        width: LibraryEntryConstants.TITLE_WIDTH,
                        height: DefinableTextUtils.calculateContentHeight(content: data.title)
                    )
                    .padding(.top, 8)
                
                HStack(alignment: .top) {
                    Text(data.author)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .padding(.bottom, 8)
                    
                    Spacer()
                    
                    NavigationLinkRightChevron {
                        ReaderView(
                            ncode: data.ncode,
                            novelTitle: data.title,
                            isActive: $isPushedToReader
                        )
                    }
                    .padding(.top, 4)
                }
                
                Divider()
            }
        }
    }
    
    private func getTitleToken(x: Int) -> Token? {
        return DefinableTextUtils.getToken(x: x, tokens: data.titleTokens)
    }
    
    func updateLastSelectedDefinableTextViewHandler(definableTextView: DefinableTextView) {
        lastSelectedDefinableTextView = definableTextView
    }
}

//struct LibraryEntryViewController_Previews: PreviewProvider {
//    static var previews: some View {
//        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//
//        let entryData = HistoryEntry(context: context)
//        entryData.ncode = "n9669bk"
//        entryData.title = "無職転生　- 異世界行ったら本気だす -"
//        entryData.author = "理不尽な孫の手"
//
//        return LibraryEntryView(entryData: entryData)
//    }
//}
