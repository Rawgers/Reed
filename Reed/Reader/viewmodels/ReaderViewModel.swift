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
    
    let paginatorWidth: CGFloat = {
        let edgeInsets = EdgeInsets()
        return UIScreen.main.bounds.width - 32
    }()
    let paginatorHeight: CGFloat = {
        let definerOffset = BottomSheetConstants.maxHeight - BottomSheetConstants.minHeight
        return UIScreen.main.bounds.height - definerOffset - 32
    }()
    
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
                annotatedContent = self.annotateWithFurigana(tokens: tokens, content: content)
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
}

// MARK: Layout logic
extension ReaderViewModel {
    private func annotateWithFurigana(tokens: [Token], content: String) -> NSMutableAttributedString {
        var annotatedContent = content as NSString
        var contentIndex = 0
        for token in tokens {
            if !token.furiganas.isEmpty {
                let start = token.range.location
                for furigana in token.furiganas {
                    annotatedContent = annotatedContent.replacingCharacters(
                        in: NSRange(
                            location: start + contentIndex + furigana.range.location,
                            length: furigana.range.length
                        ),
                        with: "｜\(token.surface[String.Index(utf16Offset: furigana.range.location, in: token.surface)..<String.Index(utf16Offset: furigana.range.location + furigana.range.length, in: token.surface)])《\(furigana.reading)》"
                    ) as NSString
                    contentIndex += furigana.reading.count + 3
                }
            } else {
                annotatedContent = annotatedContent.replacingCharacters(
                    in: NSRange(location: token.range.location + contentIndex, length: 1),
                    with: "｜\(token.surface[String.Index(utf16Offset: 0, in: token.surface)..<String.Index(utf16Offset: 1, in: token.surface)])《 》"
                ) as NSString
                contentIndex += 4
            }
        }
        
        return (annotatedContent as String).createRuby()
    }
}
