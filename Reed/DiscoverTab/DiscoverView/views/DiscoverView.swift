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
    @StateObject var viewModel = DiscoverViewModel()
    @StateObject var searchViewModel = DiscoverSearchViewModel()
    @State private var searchText: String = ""
    @State private var pushSearchResults: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView(showsIndicators: true) {
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
                        NovelList(
                            rowData: $viewModel.rows,
                            definerResultHandler: definerResults.updateEntries(entries:),
                            updateRows: viewModel.updateRows,
                            pushedViewType: .NovelDetails
                        )
                        
                        NavigationLink(
                            destination: SearchResults(
                                searchText: searchText
                            ),
                            isActive: $pushSearchResults
                        ) {
                            EmptyView()
                        }
                    }
                }
                .navigationBarTitle("Discover", displayMode: .inline)
                .searchable(
                    text: $searchText,
                    placement: .navigationBarDrawer(displayMode: .always)
                ) {
                    ForEach(searchViewModel.searchHistory, id: \.self.id) { entry in
                        if entry.text == "" {
                            Text(entry.text)
                                .foregroundColor(Color(UIColor(.primary)))
                        } else {
                            Text(entry.text)
                                .foregroundColor(Color(UIColor(.primary)))
                                .searchCompletion(entry.text)
                        }
                    }
                }
                .onSubmit(of: .search) {
                    searchViewModel.appendToSearchHistory(searchText: searchText)
                    pushSearchResults = true
                }
                .onAppear {
                    /// Can't figure out how to dismiss the search, so reset search text to fix an issue where
                    /// the search is active but no suggestions appear.
                    searchText = ""
                }
                .addDefinerAndAppNavigator(entries: $definerResults.entries)
                if viewModel.isLoading {
                    RoundedSquareProgressView()
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct DiscoverView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverView()
    }
}
