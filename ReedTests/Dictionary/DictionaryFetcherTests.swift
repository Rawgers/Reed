//
//  DictionaryFetcherTests.swift
//  ReedTests
//
//  Created by Roger Luo on 10/1/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import CoreData
import XCTest
@testable import Reed


class DictionaryFetcherTests: XCTestCase {
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle(for: type(of: self))])!
        return managedObjectModel
    }()
    
    var mockContext: NSManagedObjectContext!
    var mockContainer: NSPersistentContainer!
    var mockParser: DictionaryParser!
    var mockFetcher: DictionaryFetcher!
    
    override func setUp() {
        super.setUp()
        
        mockContainer = createMockPersistentContainer(model: managedObjectModel)
        let mockStorageManager = DictionaryStorageManager(container: mockContainer)
        mockParser = DictionaryParser(storageManager: mockStorageManager)
        mockContext = mockParser.context
        mockFetcher = DictionaryFetcher(container: mockContainer)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testFetchReadings() {
        let testData = formatTestData(
            """
            [
                {
                    "ent_seq": [
                        "1"
                    ],
                    "r_ele": [
                        {
                            "reb": [
                                "あ"
                            ]
                        }
                    ],
                    "sense": [
                        {
                            "gloss": [
                                "test"
                            ]
                        }
                    ]
                },
            ]
            """
        )
        
        let expected = ExpectedEntry(
            id: 1,
            readings: [
                ExpectedReading(reading: "あ")
            ],
            definitions: [
                ExpectedDefinition(
                    glosses: ["test"]
                )
            ]
        )
        
        mockParser.parseAndLoad(dictionaryData: testData)
        let res = mockFetcher.fetchEntries(of: "あ")
        XCTAssertEqual(res.count, 1)
        validateDictionaryEntry(created: res[0], expected: expected)
    }
    
    func testFetchTerms() {
        let testData = formatTestData(
            """
            [
                {
                    "ent_seq": [
                        "1"
                    ],
                    "k_ele": [
                        {
                            "keb": [
                                "阿"
                            ]
                        }
                    ],
                    "r_ele": [
                        {
                            "reb": [
                                "あ"
                            ]
                        }
                    ],
                    "sense": [
                        {
                            "gloss": [
                                "test"
                            ]
                        }
                    ]
                },
            ]
            """
        )
        
        let expected = ExpectedEntry(
            id: 1,
            terms: [
                ExpectedTerm(term: "阿")
            ],
            readings: [
                ExpectedReading(
                    reading: "あ",
                    terms: ["阿"]
                ),
            ],
            definitions: [
                ExpectedDefinition(
                    glosses: ["test"]
                )
            ]
        )
        
        mockParser.parseAndLoad(dictionaryData: testData)
        let res = mockFetcher.fetchEntries(of: "阿")
        XCTAssertEqual(res.count, 1)
        validateDictionaryEntry(created: res[0], expected: expected)
    }

    func testFetchEmptyResults() {
        let testData = formatTestData(
            """
            [
                {
                    "ent_seq": [
                        "1"
                    ],
                    "k_ele": [
                        {
                            "keb": [
                                "阿"
                            ]
                        }
                    ],
                    "r_ele": [
                        {
                            "reb": [
                                "あ"
                            ]
                        }
                    ],
                    "sense": [
                        {
                            "gloss": [
                                "test"
                            ]
                        }
                    ]
                },
            ]
            """
        )
        
        mockParser.parseAndLoad(dictionaryData: testData)
        var res = mockFetcher.fetchEntries(of: "お")
        XCTAssertEqual(res.count, 0)
        
        res = mockFetcher.fetchEntries(of: "御")
        XCTAssertEqual(res.count, 0)
    }
}
