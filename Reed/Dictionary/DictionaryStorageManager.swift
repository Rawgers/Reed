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
        self.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    convenience init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("DictionaryStorageManager could not get shared app delegate.")
        }
        self.init(container: appDelegate.persistentContainer)
    }
    
    func insertDictionaryEntry(entry: DictionaryEntry) {
        NSEntityDescription.insertNewObject(forEntityName: "DictionaryEntry", into: backgroundContext)
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
                print("Save error \(error)")
            }
        }
    }
}
