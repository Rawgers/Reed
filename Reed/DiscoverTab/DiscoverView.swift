//
//  DiscoverView.swift
//  Reed
//
//  Created by Roger Luo on 9/9/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import SwiftUI

struct DiscoverView: View {
    @ObservedObject var searchViewModel = DiscoverSearchViewModel()
    @ObservedObject var viewModel = DiscoverViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
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
                            updateRows: viewModel.updateRows
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
                            viewModel: searchViewModel.searchResultsViewModel
                        ),
                        isActive: $searchViewModel.pushSearchResults
                    ) {
                        EmptyView()
                    }
                }
            }
            .navigationBarTitle("Discover")
            .navigationBarSearchController(
                from: searchViewModel.searchBar,
                hidesWhenScrolling: false
            )
        }
    }
}

struct DiscoverView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverView()
    }
}
