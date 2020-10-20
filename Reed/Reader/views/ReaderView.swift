//
//  ReaderView.swift
//  Reed
//
//  Created by Roger Luo on 9/9/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import SwiftUI
import SwiftUIPager


struct ReaderView: View {
    @ObservedObject var viewModel: ReaderViewModel
    @State var page: Int = 0
    @State private var currentPosition: CGSize = .zero
    @State private var newPosition: CGSize = .zero

    var body: some View {
        VStack(alignment: .center, content: {
            Pager(page: $page,
                  data: viewModel.items,
                  id: \.self,
                  content: { text in
                    VStack(alignment: .center, spacing: /*@START_MENU_TOKEN@*/nil/*@END_MENU_TOKEN@*/, content: {
                        TextView(text: text)
                    })
            }).alignment(.start).preferredItemSize(CGSize(
                width: UIScreen.main.bounds.width,
                height: UIScreen.main.bounds.height * 0.65
            ))
            DefinitionModal()
                .frame(
                    width: UIScreen.main.bounds.width * 0.8,
                    height: UIScreen.main.bounds.height * 0.2
                ).cornerRadius(20)
                .offset(
                    x: self.currentPosition.width,
                    y: self.currentPosition.height
                ).gesture(DragGesture().onChanged { value in
                    self.currentPosition = CGSize(
                        width: value.translation.width + self.newPosition.width,
                        height: value.translation.height + self.newPosition.height
                    )
                }.onEnded { value in
                    self.currentPosition = CGSize(
                        width: value.translation.width + self.newPosition.width,
                        height: value.translation.height + self.newPosition.height
                    )
                    self.newPosition = self.currentPosition
                })
            Text("\(page + 1)")
        })
     }
}

struct TextView: UIViewRepresentable {
    var text: String!
    @EnvironmentObject var wordSelection: Word

    func makeUIView(context: UIViewRepresentableContext<TextView>) -> UIView {
        let textView = UITextView()
        textView.text = text
        textView.font = .systemFont(ofSize: 18)
        textView.addGestureRecognizer(UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.wordTapped(gesture:))))
        return textView
    }

    class Coordinator: NSObject {
        var wordSelection: Word
        var tappedRange: UITextRange!
        var selectedRange: NSRange!
        
        init(wordSelection: Word) {
            self.wordSelection = wordSelection
        }
        
        @objc func wordTapped(gesture: UITapGestureRecognizer) {
            let textView = gesture.view as! UITextView
            let location = gesture.location(in: textView)
            let position = CGPoint(x: location.x, y: location.y)
            let tapPosition = textView.closestPosition(to: position)
            tappedRange = textView.tokenizer.rangeEnclosingPosition(tapPosition!, with: UITextGranularity.word, inDirection: UITextDirection(rawValue: 1))
            if let tappedRange = tappedRange {
                if let tappedWord = textView.text(in: tappedRange) {
                    self.wordSelection.word = tappedWord
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
    }

    func makeCoordinator() -> TextView.Coordinator {
        return Coordinator(wordSelection: wordSelection)
    }

    func updateUIView(_ uiView: UIView,
                       context: UIViewRepresentableContext<TextView>) {
    }
}

struct ReaderView_Previews: PreviewProvider {
    static var previews: some View {
        ReaderView(viewModel: ReaderViewModel()).environmentObject(Word())
    }
}
