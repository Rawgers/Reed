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
    @Published var libraryEntryData = [NovelListRowData]()
    let tokenizer = Tokenizer()
    
    func fetchEntries() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<HistoryEntry> = HistoryEntry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "novelIsFavorite == true")
        do {
            let entriesCoreData: [NSFetchRequestResult] = try context.fetch(fetchRequest)
            libraryEntryData = entriesCoreData.map {
                let historyEntry = $0 as! HistoryEntry
                return NovelListRowData(
                    ncode: historyEntry.ncode,
                    title: historyEntry.title,
                    author: historyEntry.author,
                    synopsis: historyEntry.synopsis,
                    subgenre: Subgenre(rawValue: historyEntry.subgenre),
                    titleTokens: tokenizer.tokenize(historyEntry.title),
                    synopsisTokens: tokenizer.tokenize(historyEntry.synopsis)
                )
            }
        } catch {
            print("Unable to fetch entity LibraryEntry in LibraryViewModel.")
        }
    }
}
