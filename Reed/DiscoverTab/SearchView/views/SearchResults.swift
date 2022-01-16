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
    @StateObject private var definerResults: DefinerResults = DefinerResults()
    @StateObject var viewModel: DiscoverSearchResultsViewModel
    @Binding var lastSelectedDefinableTextView: DefinableTextView?
    
    init(
        searchText: String,
        lastSelectedDefinableTextView: Binding<DefinableTextView?>
    ) {
        self._viewModel = StateObject(wrappedValue: DiscoverSearchResultsViewModel(searchText: searchText))
        self._lastSelectedDefinableTextView = lastSelectedDefinableTextView
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                NovelList(
                    rowData: $viewModel.searchResults,
                    lastSelectedDefinableTextView: $lastSelectedDefinableTextView,
                    definerResultHandler: definerResults.updateEntries(entries:),
                    updateRows: viewModel.updateSearchResults,
                    pushedViewType: .NovelDetails
                )
            }
            .navigationBarTitle(viewModel.keyword, displayMode: .inline)
            .addDefinerAndAppNavigator(entries: $definerResults.entries)
            if viewModel.isLoading {
                RoundedSquareProgressView()
            }
        }
    }
}

struct SearchResults_Previews: PreviewProvider {
    static var previews: some View {
        SearchResults(
            searchText: "無職転生",
            lastSelectedDefinableTextView: .constant(DefinableTextView(coder: NSCoder()))
        )
    }
}
