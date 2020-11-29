//
//  TextView.swift
//  Reed
//
//  Created by Hugo Zhan on 11/3/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import SwiftUI

struct Term: Equatable, Hashable, Identifiable {
    var id = UUID()
    var reading: String
    var term: String
}

struct Definition: Equatable, Hashable, Identifiable {
    var id = UUID()
    var specicificLexemes: String
    var definition: String
}

struct DefinitionDetails: Equatable, Hashable, Identifiable {
    var id = UUID()
    var title: String
    var primaryReading: String
    var terms: [Term]
    var definitions: [Definition]
    
    static func == (lhs: DefinitionDetails, rhs: DefinitionDetails) -> Bool {
        return lhs.definitions == rhs.definitions
    }
}

struct DefinableTextView: UIViewRepresentable {
    @Binding var text: String
    let definerResultHandler: ([DefinitionDetails]) -> Void
    
    func makeUIView(context: UIViewRepresentableContext<DefinableTextView>) -> UITextView {
        let textView = UITextView()
        textView.isEditable = false
        textView.isSelectable = false
        textView.text = text
        textView.contentSize = CGSize(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.6)
        textView.font = .systemFont(ofSize: 17)
        textView.textAlignment = .justified
        textView.addGestureRecognizer(
            UITapGestureRecognizer(
                target: context.coordinator,
                action: #selector(Coordinator.wordTapped(gesture:))
            )
        )
        return textView
    }
    
    func updateUIView(_ textView: UITextView, context: UIViewRepresentableContext<DefinableTextView>) {
        textView.text = text
    }
    
    func makeCoordinator() -> DefinableTextView.Coordinator {
        return Coordinator(definerResultHandler: definerResultHandler)
    }
    
    class Coordinator: NSObject {
        var tappedRange: UITextRange!
        var selectedRange: NSRange!
        let dictionaryFetcher = DictionaryFetcher()
        let definerResultHandler: ([DefinitionDetails]) -> Void
        
        init(definerResultHandler: @escaping ([DefinitionDetails]) -> Void) {
            self.definerResultHandler = definerResultHandler
        }
        
        @objc func wordTapped(gesture: UITapGestureRecognizer) {
            let textView = gesture.view as! UITextView
            let location = gesture.location(in: textView)
            let position = CGPoint(x: location.x + textView.font!.pointSize / 2, y: location.y)
            let tapPosition = textView.closestPosition(to: position)
            tappedRange = textView.tokenizer.rangeEnclosingPosition(
                tapPosition!,
                with: UITextGranularity.word,
                inDirection: UITextDirection(rawValue: 1)
            )
            if let tappedRange = tappedRange {
                if let tappedWord = textView.text(in: tappedRange) {
                    highlightSelection(textView: textView)
                    defineSelection(from: tappedWord)
                }
            }
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
        
        func highlightSelection(textView: UITextView) {
            let locInt = textView.offset(from: textView.beginningOfDocument, to: tappedRange.start)
            let length = textView.offset(from: tappedRange.start, to: tappedRange.end)
            if selectedRange != nil {
                textView.textStorage.addAttribute(NSAttributedString.Key.backgroundColor, value: UIColor.clear, range: selectedRange!)
            }
            selectedRange = NSRange(location: locInt, length: length)
            textView.textStorage.addAttribute(NSAttributedString.Key.backgroundColor, value: UIColor.lightGray, range: selectedRange!)
        }
    }
}