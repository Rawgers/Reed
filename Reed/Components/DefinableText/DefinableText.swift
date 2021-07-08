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
    @Binding var content: NSMutableAttributedString
    @ObservedObject var viewModel: DefinableTextViewModel
    let width: CGFloat
    let height: CGFloat

    internal init(
        content: Binding<NSMutableAttributedString>,
        tokensRange: [Int],
        width: CGFloat,
        height: CGFloat,
        definerResultHandler: @escaping ([DefinitionDetails]) -> Void,
        getTokenHandler: @escaping (Int, Int, Int) -> Token?,
        hideNavHandler: @escaping () -> Void = {}
    ) {
        self._content = content
        self.width = width
        self.height = height
        self.viewModel = DefinableTextViewModel(
            tokensRange: tokensRange,
            definerResultHandler: definerResultHandler,
            hideNavHandler: hideNavHandler,
            getTokenHandler: getTokenHandler
        )
    }
    
    func makeUIView(
        context: UIViewRepresentableContext<DefinableText>
    ) -> DefinableTextView {
        let textView = DefinableTextView(
            frame: CGRect(x: 0, y: 0, width: width, height: height),
            content: content
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
        context.coordinator.viewModel = self.viewModel
        textView.content = self.content
        textView.content.addAttribute(NSAttributedString.Key.backgroundColor, value: UIColor.clear, range: NSRange(location: 0, length: textView.content.length))
        textView.setNeedsDisplay()
    }
    
    func makeCoordinator() -> DefinableText.Coordinator {
        return Coordinator(viewModel: viewModel)
    }
    
    class Coordinator: NSObject {
        var viewModel: DefinableTextViewModel
        
        init(
            viewModel: DefinableTextViewModel
        ) {
            self.viewModel = viewModel
        }
        
        @objc func doubleTapped() {
            viewModel.hideNavHandler()
        }
        
        @objc func wordTapped(gesture: UITapGestureRecognizer) {
            let textView = gesture.view as! DefinableTextView
            let location = gesture.location(in: textView)
            let position = CGPoint(x: location.x + textView.font.pointSize / 2, y: location.y)
            let lineArray = CTFrameGetLines(textView.ctFrame!) as! Array<CTLine>
            let tappedLine = viewModel.getLine(lineY: textView.linesYCoordinates!, l: 0, r: textView.linesYCoordinates!.count - 1, y: position.y)
            if tappedLine > -1 {
                let tappedIndex = CTLineGetStringIndexForPosition(lineArray[tappedLine], position) - 1
                print(viewModel.tokensRange)
                if let token = viewModel.getTokenHandler(viewModel.tokensRange[1], viewModel.tokensRange[2], tappedIndex + viewModel.tokensRange[0]) {
                    let location = token.range.location - viewModel.tokensRange[0]
                    let length = min(token.range.length, textView.content.length - location)
                    viewModel.tappedRange = location < 0
                        ? NSRange(location: 0, length: length + location)
                        : NSRange(location: location, length: length)
                    viewModel.highlightSelection(textView: textView)
                    viewModel.defineSelection(from: token.deinflectionResult?.text ?? "")
                }
            }
        }
    }
}
