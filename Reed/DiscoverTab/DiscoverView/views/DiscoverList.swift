//
//  DiscoverList.swift
//  Reed
//
//  Created by Roger Luo on 10/23/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import SwiftUI
import WebKit

struct DiscoverList: View {
    @Binding var rows: [DiscoverListItemViewModel]
    @Binding var lastSelectedDefinableTextView: DefinableTextView?
    let updateRows: () -> Void
    let definerResultHandler: ([DefinitionDetails]) -> Void
    
    var body: some View {
        LazyVStack(alignment: .leading) {
            Divider()
            ForEach(rows, id: \.self) { row in
                DiscoverListItem(
                    viewModel: row,
                    lastSelectedDefinableTextView: $lastSelectedDefinableTextView,
                    definerResultHandler: definerResultHandler
                )
                    .task {
                        if row == self.rows.last {
                            self.updateRows()
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
                            value: UIColor.systemYellow.withAlphaComponent(0.3),
                            range: old.selectedRange!
                        )
                        new.selectedRange = old.selectedRange
                    }
                }
            }
        }
    }
}

struct DiscoverList_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverList(
            rows: .constant([]),
            lastSelectedDefinableTextView: .constant(DefinableTextView(coder: NSCoder())),
            updateRows: {},
            definerResultHandler: { _ in }
        )
    }
}
