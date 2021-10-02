//
//  ProcessedContent.swift
//  Reed
//
//  Created by Roger Luo on 10/2/21.
//  Copyright © 2021 Roger Luo. All rights reserved.
//

struct ProcessedContent {
    let tokens: [Token]
    let annotatedContent: String
    
    init(content: String) {
        let tokenizer = Tokenizer()
        self.tokens = tokenizer.tokenize(content)
        var annotatedContent = content.annotateWithFurigana(tokens: tokens)

        // HTML does not line break unless given "<br>", so replace "\n" with "<br>".
        // Must be done after annotating to prevent index errors.
        annotatedContent = annotatedContent.replacingOccurrences(of: "\n", with: "<br>")
        self.annotatedContent = annotatedContent
    }
}
