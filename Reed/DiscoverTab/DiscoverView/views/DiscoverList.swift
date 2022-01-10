//
//  DiscoverList.swift
//  Reed
//
//  Created by Roger Luo on 10/23/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import SwiftUI

struct DiscoverList: View {
    @Binding var rows: [DiscoverListItemViewModel]
    let updateRows: () -> Void
    let definerResultHandler: ([DefinitionDetails]) -> Void
    
    var body: some View {
        LazyVStack(alignment: .leading) {
            Divider()
            ForEach(rows, id: \.self) { row in
                DiscoverListItem(
                    viewModel: row,
                    definerResultHandler: definerResultHandler
                )
                    .onAppear {
                        if row == self.rows.last {
                            self.updateRows()
                        }
                    }
            }
        }
        .padding(.horizontal)
    }
}

struct DiscoverList_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverList(
            rows: .constant([]),
            updateRows: {},
            definerResultHandler: { _ in }
        )
    }
}
