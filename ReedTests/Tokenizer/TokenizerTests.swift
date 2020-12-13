//
//  TokenizerTests.swift
//  ReedTests
//
//  Created by Shiori Yamashita on 2020/11/16.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import XCTest
@testable import Reed

class TokenizerTests: XCTestCase {
    var tokenizer: Tokenizer!

    override func setUp() {
        super.setUp()
        tokenizer = Tokenizer()
    }

    func testTokenize() {
        let tokens = tokenizer.tokenize("予算ゼロ！？　錬金術協会で基礎研究をしていましたが、退職して学生時代の友人(女騎士)の辺境開発を手伝うことにしました。")
        printTokens(tokens: tokens)
    }
    
    func printTokens(tokens: [Token]) {
        for token in tokens {
            print("=============================")
            print(token.surface)
            print("range: " + String(token.range.location) + "-" + String(NSMaxRange(token.range)))
            print("------- mecabWordNodes ------")
            dump(token.mecabWordNodes)
            print("----- deinflectionResult ----")
            dump(token.deinflectionResult)
            print("--- dictionaryDefinitions ---")
            for definition in token.dictionaryDefinitions {
                print(definition.partsOfSpeech.joined(separator: ", "))
                print(definition.glosses.joined(separator: "; "))
            }
            print("--------- furiganas ---------")
            dump(token.furiganas)
        }
    }

}
