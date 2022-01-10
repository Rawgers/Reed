//
//  SearchResults.swift
//  Reed
//
//  Created by Roger Luo on 10/28/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import SwiftUI
import struct SwiftyNarou.NarouRequest
import struct SwiftyNarou.NarouResponseFormat
import WebKit

struct SearchResults: View {
    @Binding var lastSelectedWebView: WKWebView?
    @ObservedObject var viewModel: DiscoverSearchResultsViewModel
    let definerResultHandler: ([DefinitionDetails]) -> Void
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ScrollView {
            LazyVStack {
                Divider()
                ForEach(viewModel.searchResults.indices, id: \.self) { i in
                    DiscoverListItem(
                        viewModel: viewModel.searchResults[i],
                        lastSelectedWebView: $lastSelectedWebView,
                        definerResultHandler: definerResultHandler
                    ).onAppear {
                        if self.viewModel.searchResults.last == viewModel.searchResults[i] {
                            self.viewModel.updateSearchResults()
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
        .navigationBarTitle(viewModel.keyword, displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: NavigationBackChevron(
            label: "Search",
            handleDismiss: { self.presentationMode.wrappedValue.dismiss() }
        ))
    }
}

struct SearchResults_Previews: PreviewProvider {
    static var previews: some View {
        SearchResults(
            lastSelectedWebView: .constant(WKWebView()),
            viewModel: DiscoverSearchResultsViewModel(keyword: "無職転生"),
            definerResultHandler: { _ in }
        )
    }
}
