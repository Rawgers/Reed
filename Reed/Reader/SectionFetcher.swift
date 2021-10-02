//
//  SectionFetcher.swift
//  Reed
//
//  Created by Roger Luo on 5/15/21.
//  Copyright © 2021 Roger Luo. All rights reserved.
//

import struct SwiftyNarou.SectionData

struct Section {
    let sectionNcode: String
    let data: SectionData?
}

class SectionFetcher {
    let model: ReaderModel
    @Published var section: Section?
    
    init(model: ReaderModel) {
        self.model = model
    }
    
    func fetchSection(sectionNcode: String) {
//        guard let historyEntry = model.historyEntry else {
//            fatalError("Unable to retrieve HistoryEntry.")
//        }
        
        self.section = nil
        model.fetchSectionData(sectionNcode: sectionNcode) { sectionData in
            if sectionData == nil || sectionData?.content == nil {
                
            } else {
                self.section = Section(
                    sectionNcode: sectionNcode,
                    data: sectionData
                )
            }
        }
    }
}
