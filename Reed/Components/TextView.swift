//
//  TextView.swift
//  Reed
//
//  Created by Hugo Zhan on 11/3/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import SwiftUI

struct TextView: UIViewRepresentable {
    let text: String!
    let defineSelection: (String) -> Void

    func makeUIView(context: UIViewRepresentableContext<TextView>) -> UIView {
        let textView = UITextView()
        textView.text = text
        textView.font = .systemFont(ofSize: 18)
        textView.textAlignment = .justified
        textView.addGestureRecognizer(UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.wordTapped(gesture:))))
        return textView
    }

    class Coordinator: NSObject {
        var tappedRange: UITextRange!
        var selectedRange: NSRange!
        let defineSelection: (String) -> Void
        
        init(defineSelection: @escaping (String) -> Void) {
            self.defineSelection = defineSelection
        }
        
        @objc func wordTapped(gesture: UITapGestureRecognizer) {
            let textView = gesture.view as! UITextView
            let location = gesture.location(in: textView)
            let position = CGPoint(x: location.x, y: location.y)
            let tapPosition = textView.closestPosition(to: position)
            tappedRange = textView.tokenizer.rangeEnclosingPosition(tapPosition!, with: UITextGranularity.word, inDirection: UITextDirection(rawValue: 1))
            if let tappedRange = tappedRange {
                if let tappedWord = textView.text(in: tappedRange) {
                    highlightSelection(textView: textView)
                    defineSelection(tappedWord)
                }
            }
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

    func makeCoordinator() -> TextView.Coordinator {
        return Coordinator(defineSelection: defineSelection)
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<TextView>) {}
}
