//
//  DefinableText.swift
//  Reed
//
//  Created by Hugo Zhan on 11/3/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import SwiftUI
import UIKit

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

struct DefinableText: UIViewRepresentable {
    @Binding var attributedString: NSMutableAttributedString
    var tokensRange: [Int]
    let definerResultHandler: ([DefinitionDetails]) -> Void
    let hideNavHandler: () -> Void
    let getTokenHandler: (Int, Int, Int) -> Token?
    let width: CGFloat
    let height: CGFloat
    
    func makeUIView(
        context: UIViewRepresentableContext<DefinableText>
    ) -> DefinableTextView {
        let textView = DefinableTextView(
            frame: CGRect(x: 0, y: 0, width: width, height: height),
            content: attributedString
        )
        textView.backgroundColor = .systemBackground
        
        let singleTapGesture = UITapGestureRecognizer(
            target: context.coordinator,
            action: #selector(Coordinator.wordTapped(gesture:))
        )
        singleTapGesture.numberOfTapsRequired = 1
        textView.addGestureRecognizer(singleTapGesture)
        
        let doubleTapGesture = UITapGestureRecognizer(
            target: context.coordinator,
            action: #selector(Coordinator.doubleTapped)
        )
        doubleTapGesture.numberOfTapsRequired = 2
        textView.addGestureRecognizer(doubleTapGesture)
        singleTapGesture.require(toFail: doubleTapGesture)
        
        return textView
    }
    
    func updateUIView(
        _ textView: DefinableTextView,
        context: UIViewRepresentableContext<DefinableText>
    ) {
        textView.setNeedsDisplay()
    }
    
    func makeCoordinator() -> DefinableText.Coordinator {
        return Coordinator(tokensRange: tokensRange, definerResultHandler: definerResultHandler, hideNavHandler: hideNavHandler, getTokenHandler: getTokenHandler)
    }
    
    class Coordinator: NSObject {
        var tappedRange: NSRange!
        var selectedRange: NSRange!
        let dictionaryFetcher = DictionaryFetcher()
        let tokensRange: [Int]
        let definerResultHandler: ([DefinitionDetails]) -> Void
        let hideNavHandler: () -> Void
        let getTokenHandler: (Int, Int, Int) -> Token?
        
        init(
            tokensRange: [Int],
            definerResultHandler: @escaping ([DefinitionDetails]) -> Void,
            hideNavHandler: @escaping () -> Void,
            getTokenHandler: @escaping(Int, Int, Int) -> Token?
        ) {
            self.tokensRange = tokensRange
            self.definerResultHandler = definerResultHandler
            self.hideNavHandler = hideNavHandler
            self.getTokenHandler = getTokenHandler
        }
        
        @objc func doubleTapped() {
            hideNavHandler()
        }
        
        @objc func wordTapped(gesture: UITapGestureRecognizer) {
            let textView = gesture.view as! DefinableTextView
            let location = gesture.location(in: textView)
            let position = CGPoint(x: location.x + textView.font!.pointSize / 2, y: location.y)
            let lineArray = CTFrameGetLines(textView.ctFrame!) as! Array<CTLine>
            let tappedLine = getLine(lineY: textView.lineY!, l: 0, r: textView.lineY!.count - 1, y: position.y)
            if tappedLine > -1 {
                let tappedIndex = CTLineGetStringIndexForPosition(lineArray[tappedLine], position) - 1
                if let token = getTokenHandler(tokensRange[1], tokensRange[2], tappedIndex + tokensRange[0]) {
                    let location = token.range.location - tokensRange[0]
                    let length = min(token.range.length, textView.attributedString.length - location)
                    tappedRange = location < 0
                        ? NSRange(location: 0, length: length + location)
                        : NSRange(location: location, length: length)
                    highlightSelection(textView: textView)
                    defineSelection(from: token.deinflectionResult?.text ?? "")
                }
            }
        }
        
        func getLine(lineY: [CGFloat], l: Int, r: Int, y: CGFloat) -> Int {
            if r >= l {
                let mid = l + (r - l) / 2
                if lineY[mid] >= y && lineY[mid] - 20 <= y{
                    return mid
                } else if lineY[mid] - 20 > y {
                    return getLine(lineY: lineY, l: l, r: mid - 1, y: y)
                } else {
                    return getLine(lineY: lineY, l: mid + 1, r: r, y: y)
                }
            } else {
                return -1
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
        
        func highlightSelection(textView: DefinableTextView) {
            if selectedRange != nil {
                textView.attributedString.addAttribute(NSAttributedString.Key.backgroundColor, value: UIColor.clear, range: selectedRange!)
            }
            selectedRange = tappedRange
            textView.attributedString.addAttribute(NSAttributedString.Key.backgroundColor, value: UIColor.lightGray, range: selectedRange!)
            textView.setNeedsDisplay()
        }
    }
}
