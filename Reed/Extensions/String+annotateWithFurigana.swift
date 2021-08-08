//
//  StringExtension.swift
//  Reed
//
//  Created by Hugo Zhan on 7/1/21.
//  Copyright © 2021 Roger Luo. All rights reserved.
//

import Foundation

extension String {
    func annotateWithFurigana(tokens: [Token]) -> String {
        let ADDITIONAL_CHARACTERS_PER_RUBY_ENTRY = 42
        
        var annotatedContent = self as NSString
        var contentIndex = 0
        for token in tokens {
            if !token.furiganas.isEmpty {
                let start = token.range.location
                for furigana in token.furiganas {
                    annotatedContent = annotatedContent.replacingCharacters(
                        in: NSRange(
                            location: start + contentIndex + furigana.range.location,
                            length: furigana.range.length
                        ),
                        with: generateRubyHtml(
                            tokenSurface: token.surface,
                            furigana: furigana
                        )
                    ) as NSString
                    contentIndex += furigana.reading.count + ADDITIONAL_CHARACTERS_PER_RUBY_ENTRY
                }
            }
        }
        return annotatedContent as String
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
