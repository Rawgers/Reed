//
//  HistoryEntry+CoreDataClass.swift
//  Reed
//
//  Created by Roger Luo on 11/5/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//
//

import Foundation
import CoreData

@objc(HistoryEntry)
public class HistoryEntry: NSManagedObject {
    static func create(
        context: NSManagedObjectContext,
        ncode: String,
        title: String,
        author: String,
        synopsis: String,
        subgenre: Int,
        isFavorite: Bool
    ) -> HistoryEntry? {
        let historyEntry = HistoryEntry(using: context)
        historyEntry.ncode = ncode
        historyEntry.title = title
        historyEntry.author = author
        historyEntry.synopsis = synopsis
        historyEntry.subgenre = subgenre
        historyEntry.isFavorite = isFavorite
        
        let historySection = HistorySection(using: context)
        historySection.id = 1
        historySection.novel = historyEntry
        historyEntry.lastReadSection = historySection
        do {
            try context.save()
        } catch {
            print("Unable to save to library due to error: \(error.localizedDescription)")
            return nil
        }
        
        return historyEntry
    }
    
    static func fetch(
        persistentContainer: NSPersistentContainer,
        ncode: String,
        completion: @escaping (NSManagedObjectID?) -> Void
    ) {
        let fetchRequest: NSFetchRequest<HistoryEntry> = HistoryEntry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "novelNcode == %@", ncode)
        
        persistentContainer.performBackgroundTask { context in
            do {
                let result = try context.fetch(fetchRequest)
                DispatchQueue.main.async {
                    if result.indices.contains(0) {
                        completion(result[0].objectID)
                    } else {
                        completion(nil)
                    }
                }
            } catch {
                print("Error fetching library data.")
            }
        }
    }
}
