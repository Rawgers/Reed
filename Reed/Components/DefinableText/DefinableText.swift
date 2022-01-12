//
//  DefinableText.swift
//  Reed
//
//  Created by Hugo Zhan on 11/3/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import SwiftUI
import UIKit

struct DefinableText: UIViewRepresentable {
    let id: String
    let lastSelectedDefinableTextView: DefinableTextView?
    var content: NSMutableAttributedString
    let definerResultHandler: ([DefinitionDetails]) -> Void
    let getTokenHandler: (Int) -> Token?
    let updateLastSelectedDefinableTextViewHandler: (DefinableTextView) -> Void
    
    internal init(
        id: String,
        lastSelectedDefinableTextView: DefinableTextView?,
        content: NSMutableAttributedString,
        definerResultHandler: @escaping ([DefinitionDetails]) -> Void,
        getTokenHandler: @escaping (Int) -> Token?,
        updateLastSelectedDefinableTextViewHandler: @escaping (DefinableTextView) -> Void
    ) {
        self.id = id
        self.lastSelectedDefinableTextView = lastSelectedDefinableTextView
        self.content = content
        self.definerResultHandler = definerResultHandler
        self.getTokenHandler = getTokenHandler
        self.updateLastSelectedDefinableTextViewHandler = updateLastSelectedDefinableTextViewHandler
    }
    
    func makeUIView(
        context: UIViewRepresentableContext<DefinableText>
    ) -> DefinableTextView {
        let textView = DefinableTextView(
            id: id,
            content: content
        )
        textView.backgroundColor = .systemBackground
        
        let singleTapGesture = UITapGestureRecognizer(
            target: context.coordinator,
            action: #selector(Coordinator.wordTapped(gesture:))
        )
        singleTapGesture.numberOfTapsRequired = 1
        textView.addGestureRecognizer(singleTapGesture)
        if let lastSelectedDefinableTextView = lastSelectedDefinableTextView {
            if id == lastSelectedDefinableTextView.id {
                updateLastSelectedDefinableTextViewHandler(textView)
            }
        }
        return textView
    }

    func updateUIView(
        _ textView: DefinableTextView,
        context: UIViewRepresentableContext<DefinableText>
    ) {}
    
    func makeCoordinator() -> DefinableText.Coordinator {
        return Coordinator(
            definerResultHandler: definerResultHandler,
            getTokenHandler: getTokenHandler,
            updateLastSelectedDefinableTextViewHandler: updateLastSelectedDefinableTextViewHandler
        )
    }
    
    class Coordinator: NSObject {
        private var tappedRange: NSRange!
        var selectedRange: NSRange?
        private let dictionaryFetcher = DictionaryFetcher()
        private let definerResultHandler: ([DefinitionDetails]) -> Void
        private let getTokenHandler: (Int) -> Token?
        private let updateLastSelectedDefinableTextViewHandler: (DefinableTextView) -> Void

        init(
            definerResultHandler: @escaping ([DefinitionDetails]) -> Void,
            getTokenHandler: @escaping(Int) -> Token?,
            updateLastSelectedDefinableTextViewHandler: @escaping (DefinableTextView) -> Void
        ) {
            self.definerResultHandler = definerResultHandler
            self.getTokenHandler = getTokenHandler
            self.updateLastSelectedDefinableTextViewHandler = updateLastSelectedDefinableTextViewHandler
        }
        
        @objc func wordTapped(gesture: UITapGestureRecognizer) {
            let textView = gesture.view as! DefinableTextView
            let location = gesture.location(in: textView)
            let position = CGPoint(x: location.x + textView.font.pointSize / 2, y: location.y)
            let lineArray = CTFrameGetLines(textView.ctFrame!) as! Array<CTLine>
            let tappedLine = getLine(lineY: textView.linesYCoordinates!, l: 0, r: textView.linesYCoordinates!.count - 1, y: position.y)
            if tappedLine > -1 {
                let tappedIndex = CTLineGetStringIndexForPosition(lineArray[tappedLine], position) - 1
                if let token = getTokenHandler(tappedIndex) {
                    let location = token.range.location
                    let length = min(token.range.length, textView.content.length - location)
                    tappedRange = location < 0
                        ? NSRange(location: 0, length: length + location)
                        : NSRange(location: location, length: length)
                    highlightSelection(textView: textView)
                    defineSelection(from: token.deinflectionResult?.text ?? "")
                    updateLastSelectedDefinableTextViewHandler(textView)
                }
            }
        }
        
        fileprivate func getLine(lineY: [CGFloat], l: Int, r: Int, y: CGFloat) -> Int {
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
        
        fileprivate func defineSelection(from tappedWord: String) {
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
        
        fileprivate func highlightSelection(textView: DefinableTextView) {
            if selectedRange != nil {
                textView.content.removeAttribute(
                    NSAttributedString.Key.backgroundColor,
                    range: textView.selectedRange!
                )
            }
            selectedRange = tappedRange
            textView.content.addAttribute(
                NSAttributedString.Key.backgroundColor,
                value: UIColor.systemYellow.withAlphaComponent(0.3),
                range: selectedRange!
            )
            textView.setNeedsDisplay()
            textView.selectedRange = selectedRange
        }
    }
}
