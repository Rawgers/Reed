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
    
    @Published var bookData: NarouResponse?
    @Published var isLibraryDataLoading: Bool = true
    @Published var isFavorite: Bool = false
    var libraryEntry: LibraryNovel?
    
    init(ncode: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Could not get shared app delegate.")
        }
        self.persistentContainer = appDelegate.persistentContainer
        model = NovelDetailsModel(
            persistentContainer: persistentContainer,
            ncode: ncode
        )
        
        model.fetchNovelDetails { data in
            self.bookData = data
        }
        
        model.fetchLibraryData { libraryEntryId in
            if let libraryEntryId = libraryEntryId {
                let libraryEntry = try? (
                    self.persistentContainer.viewContext.existingObject(
                        with: libraryEntryId
                    ) as? LibraryNovel
                )
                self.libraryEntry = libraryEntry
                self.isFavorite = libraryEntry?.isFavorite ?? self.isFavorite
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
        bookData?.author ?? ""
    }
    
    var novelNcode: String {
        bookData?.ncode ?? ""
    }
    
    var novelTitle: String {
        bookData?.title ?? ""
    }
    
    var novelSubgenre: Int {
        bookData?.subgenre?.rawValue ?? Subgenre.none.rawValue
    }
    
    var novelSynopsis: String {
        bookData?.synopsis?.trimmingCharacters(in: ["\n"]) ?? ""
    }
}
