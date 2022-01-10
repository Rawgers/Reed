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
    @Binding var lastSelectedWebView: WKWebView?
    let updateRows: () -> Void
    let definerResultHandler: ([DefinitionDetails]) -> Void
    
    var body: some View {
        LazyVStack(alignment: .leading) {
            Divider()
            ForEach(rows, id: \.self) { row in
                DiscoverListItem(
                    viewModel: row,
                    lastSelectedWebView: $lastSelectedWebView,
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
        .onChange(of: lastSelectedWebView) { [lastSelectedWebView] _ in
            if let lastSelectedWebView = lastSelectedWebView {
                removeHighlight(webView: lastSelectedWebView)
            }
        }
    }
    
    func removeHighlight(webView: WKWebView) {
        guard let path = Bundle.main.path(
            forResource: "RemoveHighlight.js",
            ofType: nil
        ) else {
            print("File not found.")
            return
        }
        do {
            let removeHighlightScript = try String(
                contentsOfFile: path,
                encoding: .utf8
            )
            webView.evaluateJavaScript(removeHighlightScript) { (complete, error) in
                if error != nil {
                    print(error!.localizedDescription)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct DiscoverList_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverList(
            rows: .constant([]),
            lastSelectedWebView: .constant(WKWebView()),
            updateRows: {},
            definerResultHandler: { _ in }
        )
    }
}
