//
//  ReaderModel.swift
//  Reed
//
//  Created by Roger Luo on 11/17/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import CoreData
import SwiftyNarou

class ReaderModel {
    let persistentContainer: NSPersistentContainer
    let ncode: String
    var historyEntry: HistoryEntry?
    
    init(persistentContainer: NSPersistentContainer, ncode: String) {
        self.persistentContainer = persistentContainer
        self.ncode = ncode
    }
    
    func fetchHistoryEntry(completion: @escaping (HistoryEntry) -> Void) {
        HistoryEntry.fetch(
            persistentContainer: persistentContainer,
            ncode: ncode
        ) { historyEntryId in
            guard let historyEntryId = historyEntryId,
                  let historyEntry = try? self.persistentContainer.viewContext.existingObject(
                    with: historyEntryId
                ) as? HistoryEntry
            else {
                // TODO: Add novel to library before continuing?
                fatalError("Unable to retrieve HistoryEntry.")
            }
            self.historyEntry = historyEntry
            completion(historyEntry)
        }
    }
    
    func fetchSectionData(
        sectionNcode: String,
        completion: @escaping (SectionData?) -> Void
    ) {
        guard let historyEntry = self.historyEntry
        else {
            print("No history entry.")
            return
        }
        
        historyEntry.lastReadSection.id = Int(sectionNcode.components(separatedBy: "/")[1])!
        do {
            try persistentContainer.viewContext.save()
        } catch {
            print("Unable to save HistoryEntry.")
            return
        }
        
        Narou.fetchSectionData(ncode: sectionNcode) { data, error in
            if error != nil {
                print("Failed to retrieve section content due to: \(error.debugDescription)")
                completion(nil)
            }
            completion(data)
        }
    }
}
