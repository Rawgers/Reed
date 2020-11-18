//
//  FuriganaMakerTests.swift
//  ReedTests
//
//  Created by Shiori Yamashita on 2020/11/18.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import XCTest
@testable import Reed

class FuriganaMakerTests: XCTestCase {
    var furiganaMaker: FuriganaMaker!
    
    override func setUp() {
        super.setUp()
        
        furiganaMaker = FuriganaMaker()
    }
    
    func testMakeFurigana() {
        let allKanjiFuriganas = furiganaMaker.makeFurigana(text: "洗浄", reading: "センジョウ")
        XCTAssertTrue(allKanjiFuriganas[0].range == (0, 2))
        XCTAssertEqual(allKanjiFuriganas[0].reading, "せんじょう")
        
        let noKanjiFuriganas = furiganaMaker.makeFurigana(text: "たれパンダ", reading: "タレパンダ")
        XCTAssertTrue(noKanjiFuriganas.isEmpty)
        
        let partiallyKanjiFuriganas = furiganaMaker.makeFurigana(text: "手伝う", reading: "テツダウ")
        XCTAssertTrue(partiallyKanjiFuriganas[0].range == (0, 2))
        XCTAssertEqual(partiallyKanjiFuriganas[0].reading, "てつだ")
        
        let symbolFuriganas = furiganaMaker.makeFurigana(text: "(", reading: "\"(\"")
        XCTAssertTrue(symbolFuriganas.isEmpty)
    }
    
    func testGetReadingPatternAndCount() {
        let (pattern, ranges) = furiganaMaker.getReadingPatternAndRanges(text: "百聞は一見に如かず")
        XCTAssertEqual(pattern, "(.+)は(.+)に(.+)かず")
        XCTAssertTrue(ranges[0] == (0, 2))
        XCTAssertTrue(ranges[1] == (3, 5))
        XCTAssertTrue(ranges[2] == (6, 7))
    }
    
    func testExtractReading() {
        let furiganas = furiganaMaker.extractReading(text: "百聞は一見に如かず", reading: "ひゃくぶんはいっけんにしかず")
        XCTAssertTrue(furiganas[0].range == (0, 2))
        XCTAssertEqual(furiganas[0].reading, "ひゃくぶん")
        XCTAssertTrue(furiganas[1].range == (3, 5))
        XCTAssertEqual(furiganas[1].reading, "いっけん")
        XCTAssertTrue(furiganas[2].range == (6, 7))
        XCTAssertEqual(furiganas[2].reading, "し")
    }

    func testKatakanaToHiragana() {
        XCTAssertEqual(
            furiganaMaker.katakanaToHiragana(source: "アイウエオ"),
            "あいうえお"
        )
        XCTAssertEqual(
            furiganaMaker.katakanaToHiragana(source: "123ア123"),
            "123あ123"
        )
        XCTAssertEqual(
            furiganaMaker.katakanaToHiragana(source: "生麦なまごめナマタマゴ"),
            "生麦なまごめなまたまご"
        )
    }

}
