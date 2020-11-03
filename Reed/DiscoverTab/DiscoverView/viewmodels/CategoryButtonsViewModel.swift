//
//  CategoryButtonsViewModel.swift
//  Reed
//
//  Created by Roger Luo on 10/30/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import SwiftUI
import enum SwiftyNarou.Genre

class CategoryButtonsViewModel: ObservableObject {
    @Published var buttonCategories: [DiscoverListCategory] = []
    var buttonData: [DiscoverListCategory: (label: String, icon: String)] = [:]
    
    
    init() {
        getCategories()
        getButtonData()
    }
    
    func getCategories() {
        var buttonCategories = [DiscoverListCategory]()
        buttonCategories.append(DiscoverListCategory.recent)
        for genre in Genre.allCases {
            buttonCategories.append(DiscoverListCategory.genre(genre))
        }
        self.buttonCategories = buttonCategories
    }
    
    func getButtonData() {
        for category in buttonCategories {
            switch category {
            case .recent:
                buttonData[category] = ("Recent", "exclamationmark.square")
            case .genre(let genre):
                switch genre {
                case .romance:
                    buttonData[category] = ("Romance", "heart")
                case .fantasy:
                    buttonData[category] = ("Fantasy", "burst")
                case .literature:
                    buttonData[category] = ("Literature", "text.book.closed")
                case .scifi:
                    buttonData[category] = ("Sci-fi", "circles.hexagonpath")
                case .other:
                    buttonData[category] = ("Other", "doc.plaintext")
                case .none:
                    buttonData[category] = ("Misc.", "ellipsis.rectangle")
                }
            }
        }
    }
}
