//
//  NovelDetailsModel.swift
//  Reed
//
//  Created by Roger Luo on 11/15/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import CoreData
import SwiftyNarou

class NovelDetailsModel {
    let persistentContainer: NSPersistentContainer
    let ncode: String
    
    init(persistentContainer: NSPersistentContainer, ncode: String) {
        self.persistentContainer = persistentContainer
        self.ncode = ncode
    }
    
    func fetchNovelDetails(completion: @escaping (NarouResponse?) -> Void) {
        let request = NarouRequest(
            ncode: [ncode],
            responseFormat: NarouResponseFormat(
                gzipCompressionLevel: 5,
                fileFormat: .JSON
            )
        )
        
        Narou.fetchNarouApi(request: request) { res, error in
            if error != nil {
                completion(nil)
                return
            }
            guard let res = res else {
                completion(nil)
                return
            }
            let (_, data) = res
            if !data.indices.contains(0) {
                completion(nil)
                return
            }
            completion(data[0])
        }
    }
    
    func addFavorite(
        title: String,
        author: String,
        subgenre: Int,
        completion: @escaping (NSManagedObjectID?) -> Void
    ) {
        // TODO: When we introduce error banners, check that this ncode
        // doesn't already exist in Core Data.
        
        persistentContainer.performBackgroundTask { context in
            let historyEntry = HistoryEntry.create(
                context: self.persistentContainer.viewContext,
                ncode: self.ncode,
                title: title,
                author: author,
                subgenre: subgenre,
                isFavorite: true
            )
            DispatchQueue.main.async {
                completion(historyEntry?.objectID)
            }
        }
    }
}
