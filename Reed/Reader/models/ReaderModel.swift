//
//  ReaderModel.swift
//  Reed
//
//  Created by Roger Luo on 11/17/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import SwiftyNarou

class ReaderModel {
    let ncode: String
    
    init(ncode: String) {
        self.ncode = ncode
    }
    
    func fetchSectionContent(
        sectionNcode: String,
        completion: @escaping (SectionContent?) -> Void
    ) {
        Narou.fetchSectionContent(ncode: sectionNcode) { data, error in
            if error != nil {
                print("Failed to retrieve section content due to: \(error.debugDescription)")
                completion(nil)
            }
            completion(data)
        }
    }
}
