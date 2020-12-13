//
//  DictionaryFetcher.swift
//  Reed
//
//  Created by Roger Luo on 10/1/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import CoreData
import SwiftUI


class DictionaryFetcher {
    
    let persistentContainer: NSPersistentContainer
    
    init(container: NSPersistentContainer) {
        self.persistentContainer = container
    }
    
    convenience init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Could not get shared app delegate.")
        }
        self.init(container: appDelegate.persistentContainer)
    }
    
    func fetchEntries(of key: String) -> [DictionaryEntry] {
        return isKana(key)
            ? fetchReadings(with: key).map { $0.entry }
            : fetchTerms(with: key).map { $0.entry }
    }

    func fetchReadings(with reading: String) -> [DictionaryReading] {
        let fetchRequest: NSFetchRequest<DictionaryReading> = DictionaryReading.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "readingReading == %@", reading)
        return (try? persistentContainer.viewContext.fetch(fetchRequest)) ?? []
    }

    func fetchTerms(with term: String) -> [DictionaryTerm] {
        let fetchRequest: NSFetchRequest<DictionaryTerm> = DictionaryTerm.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "termTerm == %@", term)
        return (try? persistentContainer.viewContext.fetch(fetchRequest)) ?? []
    }
    
    func countEntries(of key: String) -> Int {
        return isKana(key)
            ? countReadings(with: key)
            : countTerms(with: key)
    }
    
    func countReadings(with reading: String) -> Int {
        let fetchRequest: NSFetchRequest<DictionaryReading> = DictionaryReading.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "readingReading == %@", reading)
        return (try? persistentContainer.viewContext.count(for: fetchRequest)) ?? 0
    }
    
    func countTerms(with term: String) -> Int {
        let fetchRequest: NSFetchRequest<DictionaryTerm> = DictionaryTerm.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "termTerm == %@", term)
        return (try? persistentContainer.viewContext.count(for: fetchRequest)) ?? 0
    }
    
}
