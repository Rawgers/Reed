//
//  LibraryViewModel.swift
//  Reed
//
//  Created by Roger Luo on 9/10/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import CoreData
import SwiftUI


class LibraryViewModel: ObservableObject {
    @Published var libraryEntries = [LibraryEntryViewModel]()
    
    init() {
        insertMockCoreData()
        fetchEntries()
    }
    
    func fetchEntries() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<LibraryEntry> = LibraryEntry.fetchRequest()
        do {
            let entriesCoreData: [NSFetchRequestResult] = try context.fetch(fetchRequest)
            libraryEntries = entriesCoreData.map {
                LibraryEntryViewModel(entryData: $0 as! LibraryEntry)
            }
        } catch {
            print("Unable to fetch entity LibraryEntry in LibraryViewModel.")
            libraryEntries = []
        }
    }
    
    func insertMockCoreData() {
        if countNumCoreDataEntries() == 0 {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let n = MockLibraryEntryData.titles.count
            for i in 0..<n {
                let entry = LibraryEntry(context: context)
                entry.title = MockLibraryEntryData.titles[i]
                entry.author = MockLibraryEntryData.authors[i]
                do {
                    try context.save()
                } catch {
                    print("Unable to save LibraryEntry entity in LibraryViewModel.")
                }
            }
        }
    }
    
    func countNumCoreDataEntries() -> Int {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<LibraryEntry> = LibraryEntry.fetchRequest()
        var numEntries = 0
        
        do {
            numEntries = try context.count(for: fetchRequest)
        } catch {
            print("Unable to count entity LibraryEntry in LibraryViewModel.")
        }
        
        return numEntries
    }
}

struct LibraryViewModel_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
