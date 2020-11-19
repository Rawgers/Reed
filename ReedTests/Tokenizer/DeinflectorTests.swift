//
//  DeinflectorTests.swift
//  ReedTests
//
//  Created by Shiori Yamashita on 2020/11/17.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import XCTest
@testable import Reed

class DeinflectorTests: XCTestCase {
    var deinflector: Deinflector!

    override func setUp() {
        super.setUp()
        
        deinflector = Deinflector()
    }

    func testDeinflect() {
        let deinflectionResults = deinflector.deinflect(text: "踊りたくなかった")
        let correctDeinflectionResult = deinflectionResults.first(where: {
            $0.text == "踊る"
        })
        XCTAssertNotNil(correctDeinflectionResult)
    }

}
