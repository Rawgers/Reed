//
//  SectionFetcher.swift
//  Reed
//
//  Created by Roger Luo on 5/15/21.
//  Copyright © 2021 Roger Luo. All rights reserved.
//

import struct SwiftyNarou.SectionData

enum SectionUpdateType {
    case NEXT
    case PREV
}

struct Section {
    let data: SectionData?
    let updateType: SectionUpdateType
}

class SectionFetcher {
    let model: ReaderModel
    let setCurPage: (Int) -> Void
    @Published var section: Section?
    
    init(
        model: ReaderModel,
        setCurPage: @escaping (Int) -> Void
    ) {
        self.model = model
        self.setCurPage = setCurPage
    }
    
    private func fetchSection(sectionNcode: String, updateType: SectionUpdateType) {
//        guard let historyEntry = model.historyEntry else {
//            fatalError("Unable to retrieve HistoryEntry.")
//        }
        
        self.section = nil
        model.fetchSectionData(sectionNcode: sectionNcode) { sectionData in
            if sectionData == nil || sectionData?.content == nil {
                
            } else {
                self.section = Section(
                    data: sectionData,
                    updateType: updateType
                )
            }
        }
    }
    
    func fetchNextSection(sectionNcode: String) {
        fetchSection(sectionNcode: sectionNcode, updateType: .NEXT)
    }
    
    func fetchPrevSection(sectionNcode: String) {
        fetchSection(sectionNcode: sectionNcode, updateType: .PREV)
    }
}
