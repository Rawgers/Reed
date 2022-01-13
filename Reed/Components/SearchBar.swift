//
//  SearchControllerProvider.swift
//  Reed
//
//  Created by Roger Luo on 10/26/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import SwiftUI

class SearchBar: NSObject, ObservableObject {
    @Published var searchText: String = ""
    let searchController: UISearchController = UISearchController()
    
    var onBeginEdit: () -> Void
    var onClickSearch: (String) -> Void
    var onClickCancel: () -> Void
        
    init(
        shouldObscureBackground: Bool,
        onBeginEdit: @escaping () -> Void = {},
        onClickSearch: @escaping (String) -> Void = { _ in },
        onClickCancel: @escaping () -> Void = {}
    ) {
        self.onBeginEdit = onBeginEdit
        self.onClickSearch = onClickSearch
        self.onClickCancel = onClickCancel
        super.init()
        
        searchController.obscuresBackgroundDuringPresentation = shouldObscureBackground
        searchController.hidesNavigationBarDuringPresentation = true
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
    }
}

struct SearchBarModifier: ViewModifier {
    let searchBar: SearchBar
    let hidesWhenScrolling: Bool
    
    func body(content: Content) -> some View {
        content
            .overlay(
                ViewControllerResolver { searchController in
                    searchController.navigationItem.hidesSearchBarWhenScrolling = hidesWhenScrolling
                    searchController.navigationItem.searchController = self.searchBar.searchController
                }
                    .frame(width: 0, height: 0)
            )
    }
}

extension SearchBar: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            self.searchText = searchText
        }
    }
}

extension SearchBar: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        onBeginEdit()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        onClickSearch(searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        onClickCancel()
    }
}
