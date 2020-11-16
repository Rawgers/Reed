//
//  LibraryViewModel.swift
//  Reed
//
//  Created by Roger Luo on 9/10/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import CoreData
import SwiftyNarou
import SwiftUI

class LibraryViewModel: ObservableObject {
    @Published var novels = [LibraryNovel]()
    
    init() {
//        insertMockCoreData()
//        fetchEntries()
    }
    
    func fetchEntries() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<LibraryNovel> = LibraryNovel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "novelIsFavorite == true")
        do {
            let entriesCoreData: [NSFetchRequestResult] = try context.fetch(fetchRequest)
            novels = entriesCoreData.map {
                $0 as! LibraryNovel
            }
        } catch {
            print("Unable to fetch entity LibraryEntry in LibraryViewModel.")
            novels = []
        }
    }
    
//    func insertMockCoreData() {
//        if countNumCoreDataEntries() == 0 {
//            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//            let n = MockLibraryEntryData.titles.count
//            for i in 0..<n {
//                let entry = LibraryNovel(context: context)
//                entry.ncode = MockLibraryEntryData.ncodes[i]
//                entry.title = MockLibraryEntryData.titles[i]
//                entry.author = MockLibraryEntryData.authors[i]
//                entry.subgenre = 201
//
//                let entrySection = LibrarySection(context: context)
//                entrySection.id = 1
//                entrySection.title = "プロローグ"
//                entrySection.lastEdit = Date()
//                entrySection.novel = entry
//                entry.lastReadSection = entrySection
//                do {
//                    try context.save()
//                } catch {
//                    print("Unable to save LibraryEntry entity in LibraryViewModel.")
//                }
//            }
//        }
//    }
//
//    func countNumCoreDataEntries() -> Int {
//        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//        let fetchRequest: NSFetchRequest<LibraryNovel> = LibraryNovel.fetchRequest()
//        var numEntries = 0
//
//        do {
//            numEntries = try context.count(for: fetchRequest)
//        } catch {
//            print("Unable to count entity LibraryEntry in LibraryViewModel.")
//        }
//
//        return numEntries
//    }
}
