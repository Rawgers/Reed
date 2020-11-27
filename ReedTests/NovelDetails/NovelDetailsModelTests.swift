//
//  NovelDetailsModelTests.swift
//  ReedTests
//
//  Created by Roger Luo on 11/15/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import CoreData
import XCTest
@testable import Reed

class NovelDetailsModelTest: XCTestCase {
    lazy var managedObjectModel: NSManagedObjectModel = {
        NSManagedObjectModel.mergedModel(
            from: [Bundle(for: type(of: self))]
        )!
    }()
    var mockContainer: NSPersistentContainer!
    var mockModel: NovelDetailsModel!

    override func setUp() {
        mockContainer = createMockPersistentContainer(model: managedObjectModel)
        mockModel = NovelDetailsModel(
            persistentContainer: mockContainer,
            ncode: "n9669bk"
        )
    }
    
    func testFetchNovelDetailsSuccess() {
        let expectation = XCTestExpectation(
            description: "Fetching novel metadata from Narou."
        )
        
        mockModel.fetchNovelDetails() { novelData in
            XCTAssertNotNil(novelData)
            XCTAssertEqual(novelData!.ncode, "N9669BK")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testFetchNovelDetailsFail() {
        let expectation = XCTestExpectation(
            description: "Fetching novel metadata from Narou."
        )
        
        let mockModel = NovelDetailsModel(
            persistentContainer: mockContainer,
            ncode: "n0001aa"
        )
        mockModel.fetchNovelDetails() { novelData in
            XCTAssertNil(novelData)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testAddFavorite() {
        let title = "無職転生　- 異世界行ったら本気だす -"
        let author = "理不尽な孫の手"
        let subgenre = 201
        
        let expectation = XCTestExpectation(
            description: "Creating a new HistoryEntry with isFavorite set to true."
        )
        mockModel.addFavorite(
            title: title,
            author: author,
            subgenre: subgenre
        ) { historyEntryId in
            XCTAssertNotNil(historyEntryId, "Failed to get NSManagedObjectId of HistoryEntry.")
            
            guard let historyEntry = try? self.mockContainer.viewContext.existingObject(
                with: historyEntryId!
            ) as? HistoryEntry else {
                XCTAssertNotNil("Failed to get new HistoryEntry from its id.")
                return
            }
            
            XCTAssertEqual(historyEntry.ncode, "n9669bk")
            XCTAssertEqual(historyEntry.title, title)
            XCTAssertEqual(historyEntry.author, author)
            XCTAssertEqual(historyEntry.subgenre, subgenre)
            XCTAssertTrue(historyEntry.isFavorite)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
}
