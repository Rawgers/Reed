//
//  PartOfSpeechMatcherTests.swift
//  ReedTests
//
//  Created by Shiori Yamashita on 2020/11/14.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import XCTest
@testable import Reed

class PartOfSpeechMatcherTests: XCTestCase {
    var matcher: PartOfSpeechMatcher!
    
    override func setUp() {
        super.setUp()
        
        matcher = PartOfSpeechMatcher()
    }
    
    func testMatch() throws {
        let primary = matcher.match(
            features: ["名詞", "非自立", "一般", "*", "*", "*"],
            jmdictPartsOfSpeech: ["&n;"]
        )
        XCTAssertEqual(primary, PartOfSpeechMatchLevel.Primary)
        
        let secondary = matcher.match(
            features: ["接頭詞", "名詞接続", "*", "*", "*", "*"],
            jmdictPartsOfSpeech: ["&n;", "&adj-pn;"]
        )
        XCTAssertEqual(secondary, PartOfSpeechMatchLevel.Secondary)
        
        let none = matcher.match(
            features: ["接頭詞", "名詞接続", "*", "*", "*", "*"],
            jmdictPartsOfSpeech: ["&int;", "&exp;"]
        )
        XCTAssertEqual(none, PartOfSpeechMatchLevel.None)
    }

}
