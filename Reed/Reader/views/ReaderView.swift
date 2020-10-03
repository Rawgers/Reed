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
    var body: some View {
        Pager(page: $page,
              data: viewModel.items,
              id: \.self,
              content: { text in
                VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: /*@START_MENU_TOKEN@*/nil/*@END_MENU_TOKEN@*/, content: {
                        TextView(text: text)
                        Text("\(page + 1)")
                })
        })
            .alignment(.start)
            .preferredItemSize(CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
     }
}

struct TextView: UIViewRepresentable {
    var text: String!
    
    func makeUIView(context: UIViewRepresentableContext<TextView>) -> UIView {
        let textView = UITextView()
        textView.text = text
        textView.font = .systemFont(ofSize: 18)
        textView.addGestureRecognizer(UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.wordTapped(gesture:))))
        return textView
    }

    class Coordinator: NSObject {
        var tappedRange: UITextRange!
        var selectedRange: NSRange!
        
        @objc func wordTapped(gesture: UITapGestureRecognizer) {
            let textView = gesture.view as! UITextView
            let location = gesture.location(in: textView)
            let position = CGPoint(x: location.x, y: location.y)
            let tapPosition = textView.closestPosition(to: position)
            tappedRange = textView.tokenizer.rangeEnclosingPosition(tapPosition!, with: UITextGranularity.word, inDirection: UITextDirection(rawValue: 1))
            if let tappedRange = tappedRange {
                if let _ = textView.text(in: tappedRange) {
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
        return Coordinator()
    }

    func updateUIView(_ uiView: UIView,
                       context: UIViewRepresentableContext<TextView>) {
    }
}

struct ReaderView_Previews: PreviewProvider {
    static var previews: some View {
        ReaderView(viewModel: ReaderViewModel())
    }
}
