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
    @Published var novels = [HistoryEntry]()
    
    func fetchEntries() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<HistoryEntry> = HistoryEntry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "novelIsFavorite == true")
        do {
            let entriesCoreData: [NSFetchRequestResult] = try context.fetch(fetchRequest)
            novels = entriesCoreData.map {
                $0 as! HistoryEntry
            }
        } catch {
            print("Unable to fetch entity LibraryEntry in LibraryViewModel.")
            novels = []
        }
    }
}
