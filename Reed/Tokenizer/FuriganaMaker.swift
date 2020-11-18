//
//  FuriganaMaker.swift
//  Reed
//
//  Created by Shiori Yamashita on 2020/11/18.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import Foundation

struct Furigana {
    let range: (Int, Int)
    let reading: String
}

class FuriganaMaker {
    func makeFurigana(text: String, reading: String) -> [Furigana] {
        if text.count == 0 || reading.count == 0 {
            return []
        }
        let textWithoutKatakana = katakanaToHiragana(source: text)
        let readingInHiragana = katakanaToHiragana(source: reading)
        if !isAllHiragana(text: readingInHiragana) || textWithoutKatakana == readingInHiragana {
            return []
        }
        if isAllKanji(text: text) {
            return [Furigana(
                range: (0, text.count),
                reading: readingInHiragana
            )]
        }
        return extractReading(text: textWithoutKatakana, reading: readingInHiragana)
    }
    
    // Replace non-hiragana part with "(.+)" and return the replaced ranges
    // Example: "犬猿の仲" -> ("(.+)の(.+)", [(0, 2), (3, 4)])
    func getReadingPatternAndRanges(text: String) -> (String, [(Int, Int)]) {
        let regex = try! NSRegularExpression(pattern: "[^ぁ-ん]+")
        let range = NSRange(text.startIndex..., in: text)
        let matches = regex.matches(
            in: text,
            range: range
        )
        let ranges = matches.map {
            ($0.range.location, $0.range.location + $0.range.length)
        }
        let pattern = regex.stringByReplacingMatches(
            in: text,
            options: [],
            range: range,
            withTemplate: "(.+)"
        )
        return (pattern, ranges)
    }
    
    func extractReading(text: String, reading: String) -> [Furigana] {
        let (pattern, ranges) = getReadingPatternAndRanges(text: text)
        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            return []
        }

        guard let matched = regex.firstMatch(
            in: reading,
            range: NSRange(location: 0, length: reading.count)
        ) else {
            return []
        }

        let captureGroupIndexList = Array(1...ranges.count) // Skip 0, which is the entire match
        let matches = captureGroupIndexList.map { groupIndex -> String in
            return (reading as NSString).substring(with: matched.range(at: groupIndex))
        }
        return matches.enumerated().map {
            Furigana(
                range: ranges[$0.offset],
                reading: $0.element
            )
        }
    }
    
    func isAllHiragana(text: String) -> Bool {
        let range = "^[ぁ-ん]+$"
        return NSPredicate(format: "SELF MATCHES %@", range).evaluate(with: text)
    }
    
    func containsKanji(text: String) -> Bool {
        let range = "[\u{3005}\u{3007}\u{303b}\u{3400}-\u{9fff}\u{f900}-\u{faff}\u{20000}-\u{2ffff}]"
        return NSPredicate(format: "SELF MATCHES %@", range).evaluate(with: text)
    }
    
    func isAllKanji(text: String) -> Bool {
        let range = "^[\u{3005}\u{3007}\u{303b}\u{3400}-\u{9fff}\u{f900}-\u{faff}\u{20000}-\u{2ffff}]+$"
        return NSPredicate(format: "SELF MATCHES %@", range).evaluate(with: text)
    }
    
    func katakanaToHiragana(source: String) -> String {
        if let string = source.applyingTransform(.hiraganaToKatakana, reverse: true) {
            return string
        } else {
            return ""
        }
    }
}
