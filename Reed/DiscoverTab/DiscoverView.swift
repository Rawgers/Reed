//
//  DiscoverView.swift
//  Reed
//
//  Created by Roger Luo on 9/9/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import SwiftUI
import WebKit

struct DiscoverView: View {
    @StateObject var definerResults: DefinerResults = DefinerResults()
    @StateObject var searchViewModel = DiscoverSearchViewModel()
    @StateObject var viewModel = DiscoverViewModel()
    @State private var lastSelectedDefinableTextView: DefinableTextView?
    
    private var scrollAxis: Axis.Set {
        return searchViewModel.shouldDiscoverViewScroll ? .vertical : []
    }
    
    var body: some View {
        NavigationView {
            ScrollView(scrollAxis, showsIndicators: false) {
                ZStack {
                    VStack(alignment: .center) {
                        CategoryButtons(
                            activeCategory: $viewModel.category,
                            updateCategory: viewModel.updateCategory
                        )
                        HStack {
                            Text(viewModel.category.id)
                                .font(.title)
                                .fontWeight(.semibold)
                                .padding(.horizontal)
                            Spacer()
                        }
                        DiscoverList(
                            rows: $viewModel.rows,
                            lastSelectedDefinableTextView: $lastSelectedDefinableTextView,
                            updateRows: viewModel.updateRows,
                            definerResultHandler: definerResults.updateEntries(entries:)
                        )
                    }
                    
                    if searchViewModel.isSearching {
                        SearchHistory(
                            searchHistory: searchViewModel.searchHistory,
                            onTapRow: searchViewModel.onClickSearch
                        )
                    }

                    NavigationLink(
                        destination: SearchResults(
                            viewModel: searchViewModel.searchResultsViewModel,
                            lastSelectedDefinableTextView: $lastSelectedDefinableTextView
                        ),
                        isActive: $searchViewModel.pushSearchResults
                    ) {
                        EmptyView()
                    }
                }
            }
            .navigationBarTitle("Discover", displayMode: .inline)
            .navigationBarSearchController(
                from: searchViewModel.searchBar,
                hidesWhenScrolling: false
            )
            .addDefinerAndAppNavigator(entries: $definerResults.entries)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct DiscoverView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverView()
    }
}
