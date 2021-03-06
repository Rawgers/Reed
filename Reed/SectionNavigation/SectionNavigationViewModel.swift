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
    let handleFetchSection: (String) -> Void
    
    init(novelNcode: String, handleFetchSection: @escaping (String) -> Void) {
        self.handleFetchSection = handleFetchSection
        
        model.fetchNovelIndex(ncode: novelNcode) { novelIndex in
            guard let novelIndex = novelIndex else { return }
            self.novelTitle = novelIndex.novelTitle
            self.chapters = novelIndex.chapters
        }
    }
    
    func fetchSection(selectedSection: String) {
        handleFetchSection(selectedSection)
    }
}
