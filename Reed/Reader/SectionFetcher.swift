//
//  SectionFetcher.swift
//  Reed
//
//  Created by Roger Luo on 5/15/21.
//  Copyright © 2021 Roger Luo. All rights reserved.
//

import struct SwiftyNarou.SectionData

enum SectionUpdateType {
    case FIRST
    case NEXT
    case PREV
}

struct Section {
    let sectionNcode: String
    let data: SectionData?
    let updateType: SectionUpdateType
}

class SectionFetcher {
    let model: ReaderModel
    @Published var section: Section?
    
    init(model: ReaderModel) {
        self.model = model
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
                    sectionNcode: sectionNcode,
                    data: sectionData,
                    updateType: updateType
                )
            }
        }
    }
    
    func fetchNextSection(sectionNcode: String) {
        let sectionNumber = sectionNcode.components(separatedBy: "/")[1]
        fetchSection(
            sectionNcode: sectionNcode,
            updateType: sectionNumber == "1" ? .FIRST : .NEXT
        )
    }
    
    func fetchPrevSection(sectionNcode: String) {
        fetchSection(sectionNcode: sectionNcode, updateType: .PREV)
    }
}
