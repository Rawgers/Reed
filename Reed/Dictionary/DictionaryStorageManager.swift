//
//  DictionaryStorageManager.swift
//  Reed
//
//  Created by Roger Luo on 9/13/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import CoreData
import SwiftUI


class DictionaryStorageManager {
    
    let persistentContainer: NSPersistentContainer
    lazy var backgroundContext: NSManagedObjectContext = {
        self.persistentContainer.newBackgroundContext()
    }()
    
    init(container: NSPersistentContainer) {
        self.persistentContainer = container
    }
    
    convenience init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("DictionaryStorageManager could not get shared app delegate.")
        }
        self.init(container: appDelegate.persistentContainer)
    }
    
    func flushAll() {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "DictionaryEntry")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetch)
        do {
            try backgroundContext.execute(deleteRequest)
        } catch {
            print("Unable to delete entries.")
        }
    }

    func fetchAll() -> [DictionaryEntry] {
        let request: NSFetchRequest<DictionaryEntry> = DictionaryEntry.fetchRequest()
        let results = try? persistentContainer.viewContext.fetch(request)
        return results ?? []
    }

    func save() {
        if backgroundContext.hasChanges {
            do {
                try backgroundContext.save()
            } catch {
                print("Save error.")
            }
        }
    }
}

/// Handles the retrieval of Dictionary objects.
extension DictionaryStorageManager {
    
    func fetchEntries(key: String, isKana: Bool) -> [DictionaryEntry] {
        if isKana {
            return fetchReadings().map { $0.entry }
        }
        return fetchTerms().map { $0.entry }
    }
    
    func fetchReadings() -> [DictionaryReading] {
        let fetchRequest: NSFetchRequest<DictionaryReading> = DictionaryReading.fetchRequest()
        return (try? backgroundContext.fetch(fetchRequest)) ?? []
    }
    
    func fetchTerms() -> [DictionaryTerm] {
        let fetchRequest: NSFetchRequest<DictionaryTerm> = DictionaryTerm.fetchRequest()
        return (try? backgroundContext.fetch(fetchRequest)) ?? []
    }
    
}
