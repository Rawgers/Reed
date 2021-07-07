//
//  StringExtension.swift
//  Reed
//
//  Created by Hugo Zhan on 7/1/21.
//  Copyright © 2021 Roger Luo. All rights reserved.
//

import Foundation

extension String {
    func annotateWithFurigana(tokens: [Token]) -> NSMutableAttributedString {
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
                        with: "｜\(token.surface[String.Index(utf16Offset: furigana.range.location, in: token.surface)..<String.Index(utf16Offset: furigana.range.location + furigana.range.length, in: token.surface)])《\(furigana.reading)》"
                    ) as NSString
                    contentIndex += furigana.reading.count + 3
                }
            } else {
                annotatedContent = annotatedContent.replacingCharacters(
                    in: NSRange(location: token.range.location + contentIndex, length: 1),
                    with: "｜\(token.surface[String.Index(utf16Offset: 0, in: token.surface)..<String.Index(utf16Offset: 1, in: token.surface)])《 》"
                ) as NSString
                contentIndex += 4
            }
        }
        
        return (annotatedContent as String).createRuby()
    }
}
