//
//  StringExtension.swift
//  Reed
//
//  Created by Hugo Zhan on 7/1/21.
//  Copyright © 2021 Roger Luo. All rights reserved.
//

extension String {
    func annotateWithFurigana(tokens: [Token]) -> String {
        let ADDITIONAL_CHARACTERS_PER_RUBY_ENTRY = 42
        
        var annotatedContent = self as NSString
        var contentIndexOffset = 0
        for token in tokens {
            annotatedContent = tagToken(
                annotatedContent: annotatedContent,
                token: token,
                contentIndexOffset: &contentIndexOffset
            )
            if !token.furiganas.isEmpty {
                for furigana in token.furiganas {
                    annotatedContent = annotatedContent.replacingCharacters(
                        in: NSRange(
                            location: token.range.location + contentIndexOffset + furigana.range.location,
                            length: furigana.range.length
                        ),
                        with: generateRubyHtml(
                            tokenSurface: token.surface,
                            furigana: furigana
                        )
                    ) as NSString
                    contentIndexOffset += furigana.reading.count + ADDITIONAL_CHARACTERS_PER_RUBY_ENTRY
                }
            }
            // number of characters in </span> generated in tagToken
            contentIndexOffset += 7
        }
        return annotatedContent as String
    }
    
    private func tagToken(
        annotatedContent: NSString,
        token: Token,
        contentIndexOffset: inout Int
    ) -> NSString {
        let offsetRange = NSRange(
            location: token.range.location + contentIndexOffset,
            length: token.range.length
        )
        let wrappedToken = "<span data-surface=\"\(token.surface)\">\(token.surface)</span>"
        
        // number of characters in <span data-surface="someSurface">
        contentIndexOffset += 22 + token.range.length
        return annotatedContent.replacingCharacters(
            in: offsetRange,
            with: wrappedToken
        ) as NSString
    }
    
    private func generateRubyHtml(tokenSurface: String, furigana: Furigana) -> String {
        let base = tokenSurface[
            String.Index(
                utf16Offset: furigana.range.location,
                in: tokenSurface
            )..<String.Index(
                utf16Offset: furigana.range.location + furigana.range.length,
                in: tokenSurface
            )
        ]
        let annotation = furigana.reading
        let ruby = "<ruby>\(base)<rp>(</rp><rt>\(annotation)</rt><rp>)</rp></ruby>"
        return ruby
    }
}
