//
//  SwiftUIView.swift
//  Reed
//
//  Created by Hugo Zhan on 9/13/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import CoreData
import SwiftUI
import SwiftyNarou

struct Page: Equatable, Hashable, Identifiable {
    var id = UUID()
    var content: NSMutableAttributedString
    var tokensRange: [Int]
    static func == (lhs: Page, rhs: Page) -> Bool {
        return lhs.content == rhs.content
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

class ReaderViewModel: ObservableObject {
    let persistentContainer: NSPersistentContainer
    let model: ReaderModel
    var historyEntry: HistoryEntry?
    var section: SectionData?
    var tokens: [Token] = []
    @Published var pages: [Page] = []
    @Published var curPage: Int = -1
    
    let pagerWidth: CGFloat = {
        let edgeInsets = EdgeInsets()
        return UIScreen.main.bounds.width - 32
    }()
    let pagerHeight: CGFloat = {
        let definerOffset = BottomSheetConstants.maxHeight - BottomSheetConstants.minHeight
        return UIScreen.main.bounds.height - definerOffset - 32
    }()
    
    init(persistentContainer: NSPersistentContainer, ncode: String) {
        self.persistentContainer = persistentContainer
        self.model = ReaderModel(ncode: ncode)
        
        HistoryEntry.fetch(
            persistentContainer: persistentContainer,
            ncode: ncode
        ) { historyEntryId in
            guard let historyEntryId = historyEntryId,
                  let historyEntry = try? persistentContainer.viewContext.existingObject(
                    with: historyEntryId
                ) as? HistoryEntry
            else {
                // TODO: Add novel to library before continuing?
                fatalError("Unable to retrieve HistoryEntry.")
            }
            self.historyEntry = historyEntry
            self.fetchNextSection(sectionNcode: historyEntry.sectionNcode)
        }
    }
    
    convenience init(ncode: String) {
        let persistentContainer = getSharedPersistentContainer()
        self.init(persistentContainer: persistentContainer, ncode: ncode)
    }
    
    private func findClosest(first: Int, second: Int, x: Int) -> Int {
        if x - tokens[first].range.upperBound < tokens[second].range.lowerBound - x {
            return second
        }
        return first
    }
    
    private func getLastToken(l: Int, r: Int, x: Int) -> Int {
        if tokens.isEmpty {
            return -1
        }
        
        if x >= tokens[tokens.endIndex - 1].range.upperBound {
            return tokens.endIndex - 1
        }

        var i = l
        var j = r
        var mid = 0
        while i < j {
            mid = (i + j) / 2
            if tokens[mid].range.lowerBound <= x && tokens[mid].range.upperBound > x {
                return mid
            } else if tokens[mid].range.lowerBound > x {
                if mid > 0 && x > tokens[mid - 1].range.upperBound {
                    return findClosest(first: mid - 1, second: mid, x: x)
                }
                j = mid
            } else {
                if mid < tokens.endIndex - 1 && tokens[mid + 1].range.lowerBound > x {
                    return findClosest(first: mid, second: mid + 1, x: x)
                }
                i = mid + 1
            }
        }
        return mid
    }
    
    func getToken(l: Int, r: Int, x: Int) -> Token? {
        if r >= l {
            let mid = l + (r - l) / 2
            if tokens[mid].range.lowerBound <= x && tokens[mid].range.upperBound > x {
                return tokens[mid]
            } else if tokens[mid].range.lowerBound > x {
                return getToken(l: l, r: mid-1, x: x)
            } else {
                return getToken(l: mid + 1, r: r, x: x)
            }
        } else {
            return nil
        }
    }
}

// MARK: Layout logic
extension ReaderViewModel {
    private func annotateWithFurigana(content: String) -> NSMutableAttributedString {
        let tokenizer = Tokenizer()
        tokens = tokenizer.tokenize(content)
        
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

// MARK: Pagination logic
extension ReaderViewModel {
    private func paginate(annotatedContent: NSMutableAttributedString) -> [Page] {
        let rect = CGRect(x: 0, y: 0, width: pagerWidth, height: pagerHeight)
        var tokensSoFar = 0
        var lengthSoFar = 0
        var content = annotatedContent.mutableCopy() as! NSMutableAttributedString
        var pages = [Page]()
        if section?.prevNcode == nil {
            pages.append(Page(
                content: NSMutableAttributedString(string: "\n"),
                tokensRange: [0, 0, 0]
            ))
        }
        
        while content.length > 0 {
            let tempTextView = DefinableTextView(frame: rect, content: content)
            
            let lengthThatFits = min(tempTextView.lengthThatFits(), content.length)
            let contentStr = content.attributedSubstring(
                from: NSRange(location: 0, length: lengthThatFits)
            ).mutableCopy() as! NSMutableAttributedString
            let lastToken = getLastToken(
                l: tokensSoFar,
                r: tokens.endIndex,
                x: lengthSoFar + lengthThatFits
            )
            
            pages.append(Page(
                content: contentStr,
                tokensRange: [lengthSoFar, tokensSoFar, lastToken]
            ))
            
            tokensSoFar = lastToken
            lengthSoFar += lengthThatFits
            content = content.attributedSubstring(
                from: NSRange(
                    location: lengthThatFits,
                    length: content.length - lengthThatFits
                )
            ).mutableCopy() as! NSMutableAttributedString
        }
        
        if section?.nextNcode != nil {
            pages.append(Page(
                content: NSMutableAttributedString(string: "\n"),
                tokensRange: [0, 0, 0]
            ))
        }
        
        return pages
    }
    
    func handlePageFlip(isInit: Bool) {
        // Pager calls this function on init. Allow that first call to pass.
        if isInit { return }
        
        // Always update the previous page.
        guard let historyEntry = self.historyEntry,
              let section = self.section
        else {
            fatalError("Unable to retrieve HistoryEntry.")
        }
        if curPage == 0 && section.prevNcode != nil {
            historyEntry.lastReadSection.id -= 1
            fetchPrevSection(sectionNcode: historyEntry.sectionNcode)
        } else if curPage == pages.endIndex - 1 && section.nextNcode != nil {
            historyEntry.lastReadSection.id += 1
            fetchNextSection(sectionNcode: historyEntry.sectionNcode)
        } else { return }
        
        do {
            let persistentContainer = getSharedPersistentContainer()
            try persistentContainer.viewContext.save()
        } catch {
            print("Unable to save HistoryEntry.")
            return
        }
    }
    
    func getPageNumberDisplay() -> String {
        if section?.prevNcode == nil && section?.nextNcode == nil {
            return curPage == -1 ? "" : "\(curPage + 1) of \(pages.endIndex)"
        } else if section?.prevNcode == nil {
            return curPage == -1 || curPage + 1 > pages.endIndex - 1 ? "" : "\(curPage + 1) of \(pages.endIndex - 1)"
        } else if section?.nextNcode == nil {
            return curPage <= 0 ? "" : "\(curPage) of \(pages.endIndex - 1)"
        } else {
            return curPage <= 0 || curPage > pages.endIndex - 2 ? "" : "\(curPage) of \(pages.endIndex - 2)"
        }
    }
}

// MARK: Section logic
extension ReaderViewModel {
    private func fetchSection(sectionNcode: String, completion: @escaping () -> Void) {
        guard let historyEntry = self.historyEntry else {
            fatalError("Unable to retrieve HistoryEntry.")
        }
        self.model.fetchSectionData(sectionNcode: historyEntry.sectionNcode) { section in
            self.section = section
            let annotatedContent = self.annotateWithFurigana(content: section?.content ?? "")
            self.pages = self.paginate(annotatedContent: annotatedContent)
            completion()
        }
    }
    
    private func fetchNextSection(sectionNcode: String) {
        fetchSection(sectionNcode: sectionNcode) {
            self.curPage = self.section?.prevNcode == nil ? 0 : 1
        }
    }
    
    private func fetchPrevSection(sectionNcode: String) {
        fetchSection(sectionNcode: sectionNcode) {
            self.curPage = self.pages.endIndex - 2
        }
    }
}
