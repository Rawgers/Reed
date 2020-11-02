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
    
    init() {
        getButtonLabels()
    }
    
    func getButtonLabels() {
        var buttonCategories = [DiscoverListCategory]()
        buttonCategories.append(DiscoverListCategory.recent)
        for genre in Genre.allCases {
            buttonCategories.append(DiscoverListCategory.genre(genre))
        }
        self.buttonCategories = buttonCategories
    }
}
