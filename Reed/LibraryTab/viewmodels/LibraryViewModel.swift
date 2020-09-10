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
            print("Fetch failed: LibraryEntry in LibraryViewModel")
            libraryEntries = []
        }
    }
}
