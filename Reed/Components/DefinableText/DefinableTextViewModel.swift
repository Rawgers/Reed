//
//  DefinableTextViewModel.swift
//  Reed
//
//  Created by Hugo Zhan on 7/6/21.
//  Copyright © 2021 Roger Luo. All rights reserved.
//

import Foundation
import SwiftUI

class DefinableTextViewModel: ObservableObject {
    var tappedRange: NSRange!
    var selectedRange: NSRange!
    let dictionaryFetcher = DictionaryFetcher()
    @Published var tokensRange: [Int]
    let definerResultHandler: ([DefinitionDetails]) -> Void
    let hideNavHandler: () -> Void
    let getTokenHandler: (Int, Int, Int) -> Token?
    
    internal init(tokensRange: [Int], definerResultHandler: @escaping ([DefinitionDetails]) -> Void, hideNavHandler: @escaping () -> Void, getTokenHandler: @escaping (Int, Int, Int) -> Token?) {
        self.tokensRange = tokensRange
        self.definerResultHandler = definerResultHandler
        self.hideNavHandler = hideNavHandler
        self.getTokenHandler = getTokenHandler
    }
    
    func getLine(lineY: [CGFloat], l: Int, r: Int, y: CGFloat) -> Int {
        var i = l
        var j = r
        while j >= i {
            let mid = i + (j - i) / 2
            if lineY[mid] >= y && lineY[mid] - 20 <= y{
                return mid
            } else if lineY[mid] - 20 > y {
                j = mid - 1
            } else {
                i = mid + 1
            }
        }
        return -1
    }
    
    func defineSelection(from tappedWord: String) {
        let fetchResults = self.dictionaryFetcher.fetchEntries(of: tappedWord)
        var entries = [DefinitionDetails]()
        for result in fetchResults {
            var terms = [Term]()
            var definitions = [Definition]()
            var primaryReading = ""
            if result.readings[0].terms.endIndex > 0
                && result.readings[0].terms[0] == tappedWord
            {
                primaryReading = result.readings[0].reading
            }
            for reading in result.readings {
                for term in reading.terms {
                    terms.append(Term(reading: reading.reading, term: term))
                }
            }
            if primaryReading != "" {
                terms.removeFirst()
            }
            for sense in result.definitions {
                var definition = ""
                for gloss in sense.glosses {
                    definition += gloss + ", "
                }
                definition.removeLast(2)
                var specicificLexemes = ""
                if !sense.specificLexemes.isEmpty {
                    for specific in sense.specificLexemes {
                        specicificLexemes += specific + ", "
                    }
                    specicificLexemes.removeLast(2)
                }
                definitions.append(Definition(specicificLexemes: specicificLexemes, definition: definition))
            }
            entries.append(DefinitionDetails(title: tappedWord, primaryReading: primaryReading, terms: terms, definitions: definitions))
        }
        self.definerResultHandler(entries)
    }
    
    func highlightSelection(textView: DefinableTextView) {
        if selectedRange != nil {
            textView.content.addAttribute(NSAttributedString.Key.backgroundColor, value: UIColor.clear, range: selectedRange!)
        }
        selectedRange = tappedRange
        textView.content.addAttribute(NSAttributedString.Key.backgroundColor, value: UIColor.systemYellow.withAlphaComponent(0.3), range: selectedRange!)
        textView.setNeedsDisplay()
    }
}
