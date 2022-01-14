//
//  DiscoverSearchViewModel.swift
//  Reed
//
//  Created by Roger Luo on 10/27/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import SwiftUI

struct SearchHistoryEntry {
    let id: UUID = UUID()
    let text: String
}

class DiscoverSearchViewModel: ObservableObject {
    private let SEARCH_HISTORY_KEY = "discoverSearchHistory"
    private let MAX_HISTORY_LENGTH = 100
    
    @Published var pushSearchResults = false
    @Published var searchHistory: [SearchHistoryEntry] = [] // TODO: consider making this a queue
    
    lazy var encoder: JSONEncoder = { JSONEncoder() }()
    lazy var decoder: JSONDecoder = { JSONDecoder() }()
    
    init() {
        getSearchHistory()
    }
}

/// Methods for handling search history
extension DiscoverSearchViewModel {
    func getSearchHistory() {
        guard let searchHistoryData = UserDefaults.standard.data(
            forKey: SEARCH_HISTORY_KEY
        ) else {
            searchHistory = Array(repeating: SearchHistoryEntry(text: ""), count: MAX_HISTORY_LENGTH)
            return
        }
        
        let searchHistoryEntries = (try? decoder.decode(
            [String].self,
            from: searchHistoryData
        )) ?? []
        searchHistory = searchHistoryEntries.map { entry in
            SearchHistoryEntry(text: entry)
        }
        let emptyHistory = Array(
            repeating: SearchHistoryEntry(text: ""),
            count: MAX_HISTORY_LENGTH - searchHistory.endIndex
        )
        searchHistory.append(contentsOf: emptyHistory)
    }
    
    func appendToSearchHistory(searchText: String) {
        if searchText == searchHistory.first?.text {
            return
        }
        searchHistory.removeLast()
        searchHistory.insert(SearchHistoryEntry(text: searchText), at: 0)
        updateSearchHistoryData()
    }
    
    func clearSearchHistory() {
        searchHistory = []
        updateSearchHistoryData()
    }
    
    func updateSearchHistoryData() {
        UserDefaults.standard.set(
            (try? encoder.encode(searchHistory.map { entry in entry.text })) ?? [],
            forKey: SEARCH_HISTORY_KEY
        )
    }
}
