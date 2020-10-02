//
//  DictionaryStorageManagerTests.swift
//  ReedTests
//
//  Created by Roger Luo on 9/21/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import CoreData
import XCTest
@testable import Reed


class DictionaryStorageManagerTest: XCTestCase {
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle(for: type(of: self))] )!
        return managedObjectModel
    }()
    
    var mockParser: DictionaryParser!
    var mockContext: NSManagedObjectContext!
    var mockContainer: NSPersistentContainer!
    
    override func setUp() {
        super.setUp()
        
        mockContainer = createMockPersistentContainer(model: managedObjectModel, storeType: NSSQLiteStoreType)
        let mockStorageManager = DictionaryStorageManager(container: mockContainer)
        mockParser = DictionaryParser(storageManager: mockStorageManager)
        mockContext = mockParser.context
    }
    
    func testFetchAndFlush() {
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
        
        let fetchRequest: NSFetchRequest<DictionaryEntry> = DictionaryEntry.fetchRequest()
        var count = try! mockContext.count(for: fetchRequest)
        XCTAssertEqual(count, 0)
        
        mockParser.parseAndLoad(dictionaryData: testData)
        count = try! mockContext.count(for: fetchRequest)
        XCTAssertEqual(count, 1)
        
        mockParser.storageManager.flushAll()
        count = try! mockContext.count(for: fetchRequest)
        XCTAssertEqual(count, 0)
    }
    
}
