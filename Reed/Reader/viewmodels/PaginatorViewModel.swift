//
//  ReaderPagerViewModel.swift
//  Reed
//
//  Created by Roger Luo on 5/16/21.
//  Copyright © 2021 Roger Luo. All rights reserved.
//

import Combine
import SwiftUI

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

class PaginatorViewModel: ObservableObject {
    @Published var pages: [Page] = []
    @Published var curPage: Int = -1
    let sectionFetcher: SectionFetcher
    var processedContentCancellable: AnyCancellable?
    var tokens: [Token] = []
    
    init(
        sectionFetcher: SectionFetcher,
        processedContentPublisher: AnyPublisher<ProcessedContent?, Never>
    ) {
        self.sectionFetcher = sectionFetcher
        
        self.processedContentCancellable = processedContentPublisher.sink { [weak self] processedContent in
            guard let self = self else { return }
            guard let processedContent = processedContent else { return }
            
            self.tokens = processedContent.tokens
            self.pages = self.paginate(content: processedContent.annotatedContent)
            
            switch processedContent.sectionUpdateType {
            case .FIRST:
                self.curPage = 0
            case .NEXT:
                self.curPage = 1
            case .PREV:
                self.curPage = self.pages.endIndex - 2
            }
        }
    }
    
    deinit {
        self.processedContentCancellable?.cancel()
    }
    
    func getLastToken(l: Int, r: Int, x: Int) -> Int {
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
    
    // Used in DefinableTextView to highlight tapped token.
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
    
    private func findClosest(first: Int, second: Int, x: Int) -> Int {
        if x - tokens[first].range.upperBound < tokens[second].range.lowerBound - x {
            return second
        }
        return first
    }
    
    private func paginate(content: NSMutableAttributedString) -> [Page] {
        let rect = CGRect(
            x: 0,
            y: 0,
            width: DefinerConstants.CONTENT_WIDTH,
            height: DefinerConstants.CONTENT_HEIGHT
        )
        var tokensSoFar = 0
        var lengthSoFar = 0
        var pages = [Page]()
        
        // Add loading page if section is not the first in novel.
        if sectionFetcher.section?.data?.prevNcode != nil {
            pages.append(Page(
                content: NSMutableAttributedString(string: "\n"),
                tokensRange: [0, 0, 0]
            ))
        }
        
        let tempTextView = DefinableTextView(frame: rect, content: content)
        while lengthSoFar < content.length {
            let lengthThatFits = tempTextView.lengthThatFits(start: lengthSoFar)
            let contentStr = content.attributedSubstring(
                from: NSRange(location: lengthSoFar, length: lengthThatFits)
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
    
    func handlePageFlip() {
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
}
