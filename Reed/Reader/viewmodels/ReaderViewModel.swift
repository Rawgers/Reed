//
//  SwiftUIView.swift
//  Reed
//
//  Created by Hugo Zhan on 9/13/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import Combine
import CoreData
import SwiftUI
import SwiftyNarou

struct ProcessedContent {
    let tokens: [Token]
    let annotatedContent: NSMutableAttributedString
    let sectionUpdateType: SectionUpdateType
}

class ReaderViewModel: ObservableObject {
    @Published var processedContent: ProcessedContent?
    @Published var isLoading: Bool = true
    @Published var sectionNcode: String = ""
    
    let persistentContainer: NSPersistentContainer
    let model: ReaderModel
    let sectionFetcher: SectionFetcher
    var sectionCancellable: AnyCancellable?
    
    init(persistentContainer: NSPersistentContainer, ncode: String) {
        self.persistentContainer = persistentContainer
        self.model = ReaderModel(persistentContainer: persistentContainer, ncode: ncode)
        self.sectionFetcher = SectionFetcher(model: self.model)
        
        self.sectionCancellable = sectionFetcher.$section.sink { [weak self] section in
            guard let self = self else { return }
            guard let section = section else {
                self.isLoading = true
                return
            }
            
            var annotatedContent = NSMutableAttributedString()
            if let content = section.data?.content {
                let tokenizer = Tokenizer()
                let tokens = tokenizer.tokenize(content)
                annotatedContent = content.annotateWithFurigana(tokens: tokens)
                self.processedContent = ProcessedContent(
                    tokens: tokens,
                    annotatedContent: annotatedContent,
                    sectionUpdateType: section.updateType
                )
                self.sectionNcode = section.sectionNcode.lowercased()
            } else {
                // If the section data or its contents are nil,
                // put up some view that shows "unable to load".
            }
            
            self.isLoading = false
        }
        
        self.model.fetchHistoryEntry { historyEntry in
            self.sectionFetcher.fetchNextSection(
                sectionNcode: historyEntry.sectionNcode
            )
        }
    }
    
    convenience init(ncode: String) {
        let persistentContainer = getSharedPersistentContainer()
        self.init(persistentContainer: persistentContainer, ncode: ncode)
    }
    
    deinit {
        self.sectionCancellable?.cancel()
    }
}
