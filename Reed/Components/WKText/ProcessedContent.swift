//
//  ProcessedContent.swift
//  Reed
//
//  Created by Roger Luo on 10/2/21.
//  Copyright © 2021 Roger Luo. All rights reserved.
//

import Foundation

struct ProcessedContent {
    let tokens: [Token]
    let annotatedContent: String
    let attributedContent: NSMutableAttributedString
    
    init(content: String, withFurigana: Bool) {
        let tokenizer = Tokenizer()
        self.tokens = tokenizer.tokenize(content)
        if withFurigana {
            var annotatedContent = content.generateHtmlTokens(
                tokens: tokens,
                withFurigana: withFurigana
            )
            
            // HTML does not line break unless given "<br>", so replace "\n" with "<br>".
            // Must be done after annotating to prevent index errors.
            annotatedContent = annotatedContent.replacingOccurrences(of: "\n", with: "<br>")
            self.annotatedContent = annotatedContent
            attributedContent = NSMutableAttributedString()
        } else {
            annotatedContent = ""
            attributedContent = NSMutableAttributedString(string: content)
        }
    }
}
