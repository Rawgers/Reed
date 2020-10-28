//
//  DiscoverSearchViewModel.swift
//  Reed
//
//  Created by Roger Luo on 10/27/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import SwiftUI

class DiscoverSearchViewModel: ObservableObject {
    let searchBar: SearchBar = SearchBar(shouldObscureBackground: false)
    var searchResultsViewModel: DiscoverSearchResultsViewModel = DiscoverSearchResultsViewModel(keyword: "")
    
    @Published var isSearching: Bool = false
    @Published var pushSearchResults = false
    @Published var searchHistory: [String] = [] // TODO: consider making this a queue
    private var historyCount: Int = 0
    
    lazy var encoder: JSONEncoder = { JSONEncoder() }()
    lazy var decoder: JSONDecoder = { JSONDecoder() }()
    
    private let SEARCH_HISTORY_KEY = "discoverSearchHistory"
    private let MAX_HISTORY_LENGTH = 100
    
    init() {
        searchBar.onBeginEdit = self.onBeginEdit
        searchBar.onClickSearch = self.onClickSearch
        searchBar.onClickCancel = self.onClickCancel
        getSearchHistory()
    }
}

/// Methods for handling search history
extension DiscoverSearchViewModel {
    func getSearchHistory() {
        guard let searchHistoryData = UserDefaults.standard.data(
            forKey: SEARCH_HISTORY_KEY
        ) else {
            return
        }
        searchHistory = (try? decoder.decode(
            [String].self,
            from: searchHistoryData
        )) ?? []
        historyCount = searchHistory.count
    }
    
    func appendToSearchHistory(_ item: String) {
        if historyCount == MAX_HISTORY_LENGTH {
            searchHistory.removeFirst()
            historyCount -= 1
        }
        searchHistory.append(item)
        historyCount += 1
        updateSearchHistoryData()
    }
    
    func clearSearchHistory() {
        searchHistory = []
        historyCount = 0
        updateSearchHistoryData()
    }
    
    func updateSearchHistoryData() {
        UserDefaults.standard.set(
            (try? encoder.encode(searchHistory)) ?? [],
            forKey: SEARCH_HISTORY_KEY
        )
    }
}

/// Methods for the SearchBar
extension DiscoverSearchViewModel {
    func onClickSearch(keyword: String) {
        searchResultsViewModel = DiscoverSearchResultsViewModel(keyword: keyword)
        searchBar.searchController.searchBar.text = keyword
        appendToSearchHistory(keyword)
        pushSearchResults = true
    }
    
    func onBeginEdit() {
        isSearching = true
    }
    
    func onClickCancel() {
        isSearching = false
    }
}
