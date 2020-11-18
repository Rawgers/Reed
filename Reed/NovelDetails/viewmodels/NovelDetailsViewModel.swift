//
//  NovelDetailsViewModel.swift
//  Reed
//
//  Created by Roger Luo on 10/29/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import CoreData
import SwiftUI
import SwiftyNarou

class NovelDetailsViewModel: ObservableObject {
    let model: NovelDetailsModel
    let persistentContainer: NSPersistentContainer
    let ncode: String
    
    @Published var novelData: NarouResponse?
    @Published var isLibraryDataLoading: Bool = true
    @Published var isFavorite: Bool = false
    var libraryEntry: LibraryNovel?
    
    init(ncode: String) {
        self.ncode = ncode
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Could not get shared app delegate.")
        }
        self.persistentContainer = appDelegate.persistentContainer
        self.model = NovelDetailsModel(
            persistentContainer: persistentContainer,
            ncode: ncode
        )
        
        model.fetchNovelDetails { novelData in
            self.novelData = novelData
        }
        
        LibraryNovel.fetch(persistentContainer: persistentContainer, ncode: ncode) { libraryEntryId in
            if let libraryEntryId = libraryEntryId {
                self.libraryEntry = try? self.persistentContainer.viewContext.existingObject(
                    with: libraryEntryId
                ) as? LibraryNovel
                self.isFavorite = self.libraryEntry?.isFavorite ?? self.isFavorite
            }
            self.isLibraryDataLoading = false
        }
    }
    
    func toggleFavorite() {
        if let libraryEntry = libraryEntry {
            libraryEntry.isFavorite.toggle()
            isFavorite = libraryEntry.isFavorite
            do {
                try persistentContainer.viewContext.save()
            } catch {
                print("Failed to save changes.")
                libraryEntry.isFavorite.toggle()
            }
        } else {
            model.addFavorite(
                title: novelTitle,
                author: novelAuthor,
                subgenre: novelSubgenre
            ) { libraryEntry in
                self.libraryEntry = libraryEntry
                self.isFavorite = true
            }
        }
    }
}

// Unwrap and postprocess NarouResponse optionals for readability
extension NovelDetailsViewModel {
    var novelAuthor: String {
        novelData?.author ?? ""
    }
    
    var novelNcode: String {
        novelData?.ncode ?? ""
    }
    
    var novelTitle: String {
        novelData?.title ?? ""
    }
    
    var novelSubgenre: Int {
        novelData?.subgenre?.rawValue ?? Subgenre.none.rawValue
    }
    
    var novelSynopsis: String {
        novelData?.synopsis?.trimmingCharacters(in: ["\n"]) ?? ""
    }
}
