//
//  UtilsTests.swift
//  ReedTests
//
//  Created by Roger Luo on 10/2/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import XCTest
@testable import Reed


class UtilsTests: XCTestCase {

    func testIsKana() {
        let trueInputs = [
            "あ",
            "あお",
            "アオ",
        ]
        
        let falseInputs = [
            "蒼",
            "蒼天",
            "ABC"
        ]
        
        for input in trueInputs {
            XCTAssertTrue(isKana(input))
        }
        
        for input in falseInputs {
            XCTAssertFalse(isKana(input))
        }
    }

}
