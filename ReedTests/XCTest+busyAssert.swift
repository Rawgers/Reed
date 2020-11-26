//
//  XCTest+busyAssert.swift
//  ReedTests
//
//  Created by Roger Luo on 11/25/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import XCTest

extension XCTest {
    // source: https://www.vadimbulavin.com/unit-testing-async-code-in-swift/
    func busyAssert(
        _ isFulfilled: @autoclosure () -> Bool,
        timeout: TimeInterval,
        message: String = "",
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        func wait() {
            RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.01))
        }
        
        let timeout = Date(timeIntervalSinceNow: timeout)
        func isTimeout() -> Bool { Date() >= timeout }

        repeat {
            if isFulfilled() { return }
            wait()
        } while !isTimeout()
        
        XCTFail(message, file: file, line: line)
    }
}
