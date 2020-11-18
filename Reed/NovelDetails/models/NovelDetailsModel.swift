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
    
    func fetchNovelDetails(completion: @escaping (NarouResponse) -> Void) {
        let request = NarouRequest(
            ncode: [ncode],
            responseFormat: NarouResponseFormat(
                gzipCompressionLevel: 5,
                fileFormat: .JSON
            )
        )
        
        Narou.fetchNarouApi(request: request) { data, error in
            if error != nil { return }
            guard let data = data else { return }
            completion(data.1[0])
        }
    }
    
    func addFavorite(
        title: String,
        author: String,
        subgenre: Int,
        completion: @escaping (LibraryNovel?) -> Void
    ) {
        persistentContainer.performBackgroundTask { context in
            context.retainsRegisteredObjects = true
            let libraryEntry = LibraryNovel.create(
                context: self.persistentContainer.viewContext,
                ncode: self.ncode,
                title: title,
                author: author,
                subgenre: subgenre,
                isFavorite: true
            )
            DispatchQueue.main.async {
                completion(libraryEntry)
            }
        }
    }
}
