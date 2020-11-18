//
//  SwiftUIView.swift
//  Reed
//
//  Created by Hugo Zhan on 9/13/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import SwiftUI
import SwiftyNarou

class ReaderViewModel: ObservableObject {
    let model: ReaderModel
    var libraryEntry: LibraryNovel?
    var content: String = ""
    @Published var items = [String]()
    
    init(ncode: String) {
        self.model = ReaderModel(ncode: ncode)
        let persistentContainer = getSharedPersistentContainer()
        
        LibraryNovel.fetch(
            persistentContainer: persistentContainer,
            ncode: ncode
        ) { libraryEntryId in
            if libraryEntryId != nil {
                self.libraryEntry = try? persistentContainer.viewContext.existingObject(
                    with: libraryEntryId!
                ) as? LibraryNovel
            }
            
            guard let libraryEntry = self.libraryEntry else {
                // TODO: Add novel to library before continuing?
                fatalError("Unable to retrieve LibraryNovel.")
            }
            
            self.model.fetchSectionContent(sectionNcode: libraryEntry.sectionNcode) { section in
                self.content = section?.content ?? ""
                self.calcPages()
            }
        }
    }
    
    func calcPages() {
        let userWidth  = UIScreen.main.bounds.width
        let userHeight = UIScreen.main.bounds.height * 0.55
        let rect = CGRect(x: 0, y: 0, width: userWidth, height: userHeight)
        let tempTextView = UITextView(frame: rect)
        tempTextView.font = UIFont.systemFont(ofSize: 18)
        
        while content != "" {
            tempTextView.text = content
            
            let layoutManager = tempTextView.layoutManager
            layoutManager.ensureLayout(for: tempTextView.textContainer)

            let rangeThatFits = layoutManager.glyphRange(
                forBoundingRect: rect,
                in: tempTextView.textContainer
            )

            guard let stringRange = Range(rangeThatFits, in: content) else { return }
            
            items.append(String(content[stringRange]))
            content = String(content[stringRange.upperBound..<content.endIndex])
        }
    }
}
