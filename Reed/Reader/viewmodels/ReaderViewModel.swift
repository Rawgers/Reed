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
    lazy var sectionFetcher: SectionFetcher = {
        SectionFetcher(
            model: model,
            setCurPage: setCurPage
        )
    }()
    
    var sectionCancellable: AnyCancellable?
    var tokens: [Token] = []
    var ncode: String
    @Published var pages: [Page] = []
    @Published var curPage: Int = -1
    
    var sectionNcode: String {
        return model.historyEntry?.sectionNcode ?? ""
    }
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
        self.model = ReaderModel(persistentContainer: persistentContainer, ncode: ncode)
        self.ncode = ncode
        
        self.sectionCancellable = sectionFetcher.$section.sink { [weak self] section in
            guard let self = self else { return }
            guard let section = section else {
                self.clearPaginator()
                return
            }
            
            var annotatedContent = NSMutableAttributedString()
            if let content = section.data?.content {
                let tokenizer = Tokenizer()
                self.tokens = tokenizer.tokenize(content)
                annotatedContent = self.annotateWithFurigana(tokens: self.tokens, content: content)
            } else {
                // If the section data or its contents are nil,
                // put up some view that shows "unable to load".
            }
            // may need to dispatch assignment to main
            self.pages = self.paginate(annotatedContent: annotatedContent)
            
            switch section.updateType {
            case .NEXT:
                self.curPage = section.data?.prevNcode == nil ? 0 : 1
            case .PREV:
                self.curPage = self.pages.endIndex - 2
            }
        }
        
        self.clearPaginator()
        self.model.fetchHistoryEntry { historyEntry in
            self.sectionFetcher.fetchNextSection(sectionNcode: historyEntry.sectionNcode)
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

// MARK: Pagination logic
extension ReaderViewModel {
    private func paginate(annotatedContent: NSMutableAttributedString) -> [Page] {
        let rect = CGRect(x: 0, y: 0, width: pagerWidth, height: pagerHeight)
        var tokensSoFar = 0
        var lengthSoFar = 0
        var content = annotatedContent.mutableCopy() as! NSMutableAttributedString
        var pages = [Page]()
        
        // Add loading page if section is not the first in novel.
        if sectionFetcher.section?.data?.prevNcode != nil {
            pages.append(Page(
                content: NSMutableAttributedString(string: "\n"),
                tokensRange: [0, 0, 0]
            ))
        }
        
        let tempTextView = DefinableTextView(frame: rect, content: NSMutableAttributedString(string: ""))
        while content.length > 0 {
            tempTextView.content = content
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
        
        // Add loading page if section is not the last in novel.
        if sectionFetcher.section?.data?.nextNcode != nil {
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
        
        // Handle cases when flipping first or last page of section.
        guard let sectionData = sectionFetcher.section?.data else { return }
        if curPage == 0 && sectionData.prevNcode != nil {
            sectionFetcher.fetchPrevSection(sectionNcode: sectionData.prevNcode!)
        } else if curPage == pages.endIndex - 1 && sectionData.nextNcode != nil {
            sectionFetcher.fetchNextSection(sectionNcode: sectionData.nextNcode!)
        } else { return }
    }
    
    func getPageNumberDisplay() -> String {
        guard let section = sectionFetcher.section else { return "" }
        let sectionData = section.data
        
        if sectionData?.prevNcode == nil && sectionData?.nextNcode == nil {
            return curPage == -1 ? "" : "\(curPage + 1) of \(pages.endIndex)"
        } else if sectionData?.prevNcode == nil {
            return curPage == -1 || curPage + 1 > pages.endIndex - 1 ? "" : "\(curPage + 1) of \(pages.endIndex - 1)"
        } else if sectionData?.nextNcode == nil {
            return curPage <= 0 ? "" : "\(curPage) of \(pages.endIndex - 1)"
        } else {
            return curPage <= 0 || curPage > pages.endIndex - 2 ? "" : "\(curPage) of \(pages.endIndex - 2)"
        }
    }
    
    func clearPaginator() {
        curPage = -1
        pages = [Page(
            content: NSMutableAttributedString(string: "\n"),
            tokensRange: [0, 0, 0]
        )]
    }
    
    func setCurPage(newPage: Int) {
        curPage = newPage
    }
}
