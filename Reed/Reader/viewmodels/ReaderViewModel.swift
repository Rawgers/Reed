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
    var content: String
    var tokens: [Token]
    
    static func == (lhs: Page, rhs: Page) -> Bool {
        return lhs.content == rhs.content
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

class ReaderViewModel: ObservableObject {
    let persistentContainer: NSPersistentContainer
    let ncode: String
    let model: ReaderModel
    var section: SectionData?
    @Published var items = [String]()
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
        self.ncode = ncode
        self.model = ReaderModel(persistentContainer: persistentContainer, ncode: ncode)
        self.model.fetchHistoryEntry { historyEntry in
            self.fetchNextSection(sectionNcode: historyEntry.sectionNcode)
        }
    }
    
    convenience init(ncode: String) {
        let persistentContainer = getSharedPersistentContainer()
        self.init(persistentContainer: persistentContainer, ncode: ncode)
    }
    
    func fetchNextSection(sectionNcode: String) {
        fetchSection(sectionNcode: sectionNcode) {
            self.curPage = self.section?.prevNcode == nil ? 0 : 1
        }
    }
    
    func fetchPrevSection(sectionNcode: String) {
        fetchSection(sectionNcode: sectionNcode) {
            self.curPage = self.pages.endIndex - 2
        }
    }
    
    func fetchSection(sectionNcode: String, completion: @escaping () -> Void) {
        self.model.fetchSectionData(sectionNcode: sectionNcode) { section in
            self.section = section
            self.pages = self.calcPages(content: section?.content ?? "")
            completion()
        }
    }
    
    func calcPages(content: String) -> [Page] {
        let rect = CGRect(x: 0, y: 0, width: pagerWidth, height: pagerHeight)
        let tempTextView = UITextView(frame: rect)
        tempTextView.font = .systemFont(ofSize: 20)
        tempTextView.textAlignment = .justified
        
        var remainingContent = content
        var pages = section?.prevNcode == nil ? [] : [Page(content: "", tokens: [])]
        let tokenizer = Tokenizer()
        while remainingContent != "" {
            tempTextView.text = remainingContent
            
            let layoutManager = tempTextView.layoutManager
            layoutManager.ensureLayout(for: tempTextView.textContainer)

            let rangeThatFits = layoutManager.glyphRange(
                forBoundingRect: rect,
                in: tempTextView.textContainer
            )
            guard let stringRange = Range(
                rangeThatFits,
                in: remainingContent
            ) else {
                print("Problem paginating section content.")
                return pages
            }
            
            let contentStr = String(remainingContent[stringRange])
            pages.append(Page(content: contentStr, tokens: tokenizer.tokenize(contentStr)))
            remainingContent = String(remainingContent[stringRange.upperBound..<remainingContent.endIndex])
        }
        if section?.nextNcode != nil {
            pages.append(Page(content: "\n", tokens: []))
        }
        return pages
    }
    
    func handlePageFlip(isInit: Bool) {
        // Pager calls this function on init. Allow that first call to pass.
        if isInit { return }
        
        // Always update the previous page.
        guard let section = self.section
        else {
            fatalError("Unable to retrieve HistoryEntry.")
        }
        if curPage == 0 && section.prevNcode != nil {
            fetchPrevSection(sectionNcode: section.prevNcode!)
        } else if curPage == pages.endIndex - 1 && section.nextNcode != nil {
            fetchNextSection(sectionNcode: section.nextNcode!)
        } else { return }
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
