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
    let persistentContainer: NSPersistentContainer
    let model: NovelDetailsModel
    let ncode: String
    
    @Published var novelData: NarouResponse?
    @Published var isLibraryDataLoading: Bool = true
    @Published var isNovelSynopsisProcessing: Bool = true
    @Published var isFavorite: Bool = false
    @Published var novelSynopsis = NSMutableAttributedString()
    @Published var novelSynopsisHeight = DefinerConstants.CONTENT_HEIGHT
    var historyEntry: HistoryEntry?
    var tokens = [Token]()
    
    init(persistentContainer: NSPersistentContainer, ncode: String) {
        self.persistentContainer = persistentContainer
        self.model = NovelDetailsModel(
            persistentContainer: persistentContainer,
            ncode: ncode
        )
        self.ncode = ncode
        
        // Fetch metadata from Narou.
        model.fetchNovelDetails { novelData in
            self.novelData = novelData
            let tokenizer = Tokenizer()
            self.tokens = tokenizer.tokenize(novelData?.synopsis ?? "")
            self.novelSynopsis = (novelData?.synopsis?.trimmingCharacters(in: ["\n"]) ?? "").annotateWithFurigana(tokens: self.tokens)
            //calculations
            let testDefinableTextView = DefinableTextView(
                frame: CGRect(
                    x: 0,
                    y: 0,
                    width: DefinerConstants.CONTENT_WIDTH,
                    height: DefinerConstants.NOVEL_SYNOPSIS_PRELOAD_HEIGHT
                ),
                content: self.novelSynopsis
            )
            self.novelSynopsisHeight = (testDefinableTextView.getLinesYCoordinates().last ?? DefinerConstants.CONTENT_HEIGHT) + testDefinableTextView.font.pointSize
            self.isNovelSynopsisProcessing = false
        }
        
        // Fetch HistoryEntry if it exists.
        HistoryEntry.fetch(persistentContainer: persistentContainer, ncode: ncode) { historyEntryId in
            if let historyEntryId = historyEntryId {
                self.historyEntry = try? self.persistentContainer.viewContext.existingObject(
                    with: historyEntryId
                ) as? HistoryEntry
                self.isFavorite = self.historyEntry?.isFavorite ?? self.isFavorite
            }
            self.isLibraryDataLoading = false
        }
    }
    
    convenience init(ncode: String) {
        let persistentContainer = getSharedPersistentContainer()
        self.init(persistentContainer: persistentContainer, ncode: ncode)
    }
    
    func toggleFavorite() {
        if let historyEntry = historyEntry {
            historyEntry.isFavorite.toggle()
            self.isFavorite = historyEntry.isFavorite
            do {
                try persistentContainer.viewContext.save()
            } catch {
                print("Failed to save changes.")
                historyEntry.isFavorite.toggle()
            }
        } else {
            model.addFavorite(
                title: novelTitle,
                author: novelAuthor,
                subgenre: novelSubgenre!.rawValue
            ) { historyEntryId in
                if let historyEntryId = historyEntryId {
                    self.historyEntry = try? self.persistentContainer.viewContext.existingObject(
                        with: historyEntryId
                    ) as? HistoryEntry
                    self.isFavorite = true
                }
            }
        }
    }
    
    // TODO: Perhaps pass the historyEntry directly to Reader?
    func onPushToReader() {
        if historyEntry != nil { return }
        
        historyEntry = HistoryEntry.create(
            context: persistentContainer.viewContext,
            ncode: novelNcode,
            title: novelTitle,
            author: novelAuthor,
            subgenre: novelSubgenre!.rawValue,
            isFavorite: false
        )
    }
    
    func getToken(l: Int, r: Int, x: Int) -> Token? {
        var i = l
        var j = r
        while j >= i {
            let mid = i + (j - i) / 2
            if tokens[mid].range.lowerBound <= x && tokens[mid].range.upperBound > x {
                return tokens[mid]
            } else if tokens[mid].range.lowerBound > x {
                j = mid - 1
            } else {
                i = mid + 1
            }
        }
        return nil
    }
}

// Unwrap and postprocess NarouResponse optionals for readability
extension NovelDetailsViewModel {
    var novelNcode: String {
        novelData?.ncode ?? ""
    }
    
    var novelTitle: String {
        novelData?.title ?? ""
    }
    
    var novelAuthor: String {
        novelData?.author ?? ""
    }
    
    var novelSubgenre: Subgenre? {
        novelData?.subgenre
    }
    
    var novelKeywords: [String] {
        novelData?.keyword ?? []
    }
}
