//
//  SwiftUIView.swift
//  Reed
//
//  Created by Hugo Zhan on 9/13/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import SwiftUI


class ReaderViewModel: ObservableObject {
    
    var items = [String]()
    var font = UIFont.systemFont(ofSize: 18)
    var content: String = ""
    
    init(ncode: String) {
        fetchSectionContents()
        calcPages()
    }
    
    func fetchSectionContents() {
        content = MockReaderData.content[0]
    }
    
    func calcPages() {
        let userWidth  = UIScreen.main.bounds.width
        let userHeight = UIScreen.main.bounds.height * 0.6
        let rect = CGRect(x: 0, y: 0, width: userWidth, height: userHeight)
        let tempTextView = UITextView(frame: rect)
        tempTextView.font = font
        
        while (content.count > 0) {
            tempTextView.text = content
            
            let layoutManager = tempTextView.layoutManager
            layoutManager.ensureLayout(for: tempTextView.textContainer)

            let rangeThatFits = layoutManager.glyphRange(forBoundingRect: rect, in: tempTextView.textContainer)

            guard let stringRange = Range(rangeThatFits, in: content) else {
                return
            }
            
            items.append(String(content[stringRange]))
            content = String(content[stringRange.upperBound..<content.endIndex])
        }
    }
    
}
