//
//  SectionNavigationModel.swift
//  Reed
//
//  Created by Roger Luo on 1/20/21.
//  Copyright © 2021 Roger Luo. All rights reserved.
//

import SwiftyNarou

class SectionNavigationModel {
    func fetchNovelIndex(
        ncode: String,
        completion: @escaping (NovelIndex?) -> Void
    ) {
        Narou.fetchNovelIndex(ncode: ncode) { data, error in
            if error != nil {
                completion(nil)
                return
            }
            completion(data)
        }
    }
}
