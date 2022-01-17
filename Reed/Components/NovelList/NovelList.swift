//
//  NovelListView.swift
//  Reed
//
//  Created by Roger Luo on 1/15/22.
//  Copyright © 2022 Roger Luo. All rights reserved.
//

import SwiftUI

struct NovelList: View {
    @State private var lastSelectedDefinableTextView: DefinableTextView?
    @Binding var rowData: [NovelListRowData]
    let definerResultHandler: ([DefinitionDetails]) -> Void
    let updateRows: () -> Void
    let pushedViewType: PushedViewType
    
    var body: some View {
        LazyVStack(alignment: .leading) {
            Divider()
            ForEach(rowData, id: \.self) { data in
                ZStack {
                    NovelListRow(
                        data: data,
                        definerResultHandler: definerResultHandler,
                        lastSelectedDefinableTextView: $lastSelectedDefinableTextView,
                        pushedViewType: pushedViewType
                    )
                        .task {
                            if data == self.rowData.last {
                                self.updateRows()
                            }
                        }
                }
            }
        }
        .padding(.horizontal)
        .onChange(of: lastSelectedDefinableTextView) { [lastSelectedDefinableTextView] newSelectedDefinableTextView in
            if let old = lastSelectedDefinableTextView {
                old.content.removeAttribute(
                    NSAttributedString.Key.backgroundColor,
                    range: old.selectedRange!
                )
                old.setNeedsDisplay()
                
                if let new = newSelectedDefinableTextView {
                    if new.id == old.id {
                        new.content.addAttribute(
                            NSAttributedString.Key.backgroundColor,
                            value: UIColor.clear,
                            range: old.selectedRange!
                        )
                        new.selectedRange = old.selectedRange
                    }
                }
            }
        }
    }
}
