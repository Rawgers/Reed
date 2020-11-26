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
            description: "Creating a new LibraryNovel with isFavorite set to true."
        )
        mockModel.addFavorite(
            title: title,
            author: author,
            subgenre: subgenre
        ) { libraryNovelId in
            XCTAssertNotNil(libraryNovelId, "Failed to get NSManagedObjectId of LibraryNovel.")
            
            guard let libraryEntry = try? self.mockContainer.viewContext.existingObject(
                with: libraryNovelId!
            ) as? LibraryNovel else {
                XCTAssertNotNil("Failed to get new LibraryNovel from its id.")
                return
            }
            
            XCTAssertEqual(libraryEntry.ncode, "n9669bk")
            XCTAssertEqual(libraryEntry.title, title)
            XCTAssertEqual(libraryEntry.author, author)
            XCTAssertEqual(libraryEntry.subgenre, subgenre)
            XCTAssertTrue(libraryEntry.isFavorite)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
}
