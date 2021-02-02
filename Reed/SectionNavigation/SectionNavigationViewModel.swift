//
//  SectionNavigationViewModel.swift
//  Reed
//
//  Created by Roger Luo on 1/16/21.
//  Copyright © 2021 Roger Luo. All rights reserved.
//

import SwiftyNarou

class SectionNavigationViewModel: ObservableObject {
    @Published var novelTitle: String = ""
    @Published var chapters: [Chapter] = []
    let model: SectionNavigationModel = SectionNavigationModel()
    let novelNcode: String
    let sectionNumber: Int
    
    
    init(sectionNcode: String) {
        let sectionNcodeParts = sectionNcode.components(separatedBy: "/")
        self.novelNcode = sectionNcodeParts[0]
        self.sectionNumber = Int(sectionNcodeParts[1])!
        
        model.fetchNovelIndex(ncode: novelNcode) { novelIndex in
            guard let novelIndex = novelIndex else { return }
            self.novelTitle = novelIndex.novelTitle
            self.chapters = novelIndex.chapters
        }
    }
}
