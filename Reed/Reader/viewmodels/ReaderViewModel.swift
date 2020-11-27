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

class ReaderViewModel: ObservableObject {
    let persistentContainer: NSPersistentContainer
    let model: ReaderModel
    var historyEntry: HistoryEntry?
    var section: SectionContent?
    
    @Published var pages: [String] = []
    @Published var curPage: Int = 0
    var lastPage: Int = 0
    
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
    
    func fetchNextSection(sectionNcode: String) {
        fetchSection(sectionNcode: sectionNcode) {
            self.lastPage = 0
            self.curPage = 0
        }
    }
    
    func fetchPrevSection(sectionNcode: String) {
        fetchSection(sectionNcode: sectionNcode) {
            self.lastPage = self.pages.endIndex - 1
            self.curPage = self.pages.endIndex - 1
        }
    }
    
    private func fetchSection(sectionNcode: String, completion: @escaping () -> Void) {
        guard let historyEntry = self.historyEntry else {
            fatalError("Unable to retrieve HistoryEntry.")
        }
        self.model.fetchSectionContent(sectionNcode: historyEntry.sectionNcode) { section in
            self.section = section
            self.pages = self.calcPages(content: section?.content ?? "")
            completion()
        }
    }
    
    func calcPages(content: String) -> [String] {
        let userWidth = UIScreen.main.bounds.width
        let userHeight = UIScreen.main.bounds.height * 0.55
        let rect = CGRect(x: 0, y: 0, width: userWidth, height: userHeight)
        let tempTextView = UITextView(frame: rect)
        tempTextView.font = UIFont.systemFont(ofSize: 18)
        
        var remainingContent = content
        var pages = [String]()
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
            
            pages.append(String(remainingContent[stringRange]))
            remainingContent = String(remainingContent[stringRange.upperBound..<remainingContent.endIndex])
        }
        
        return pages
    }
    
    func handlePageFlip(isInit: Bool) {
        // Pager calls this function on init. Allow that first call to pass.
        if isInit { return }
        
        // Always update the previous page.
        defer { lastPage = curPage }
        
        guard let historyEntry = self.historyEntry,
              let section = self.section
        else {
            fatalError("Unable to retrieve HistoryEntry.")
        }
        if lastPage == 0 && curPage == 0 && section.prevNcode != nil {
            historyEntry.lastReadSection.id -= 1
            fetchPrevSection(sectionNcode: historyEntry.sectionNcode)
        } else if lastPage == pages.endIndex - 1
                    && curPage == pages.endIndex - 1
                    && section.nextNcode != nil
        {
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
}
