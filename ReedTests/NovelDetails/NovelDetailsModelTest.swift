//
//  NovelDetailsModelTest.swift
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
        mockModel = NovelDetailsModel(persistentContainer: mockContainer, ncode: "n9669bk")
    }
    
    func testAddFavorite() {
        let fetchLibraryNovel: NSFetchRequest<LibraryNovel> = LibraryNovel.fetchRequest()
        let fetchLibrarySection: NSFetchRequest<LibrarySection> = LibrarySection.fetchRequest()
        do {
            let count = try self.mockContainer.viewContext.count(for: fetchLibraryNovel)
            XCTAssertEqual(count, 0)
        } catch {
            print("Failed to count LibraryNovel.")
        }
        
        do {
            let count = try self.mockContainer.viewContext.count(for: fetchLibrarySection)
            XCTAssertEqual(count, 0)
        } catch {
            print("Failed to count LibrarySection.")
        }
        
        let expectation = XCTestExpectation(description: "Adding to favorites.")
        mockModel.addFavorite(
            title: "無職転生　- 異世界行ったら本気だす -",
            author: "理不尽な孫の手",
            subgenre: 201
        ) { libraryNovel in
            guard let libraryNovel = libraryNovel else {
                XCTFail()
                return
            }
            XCTAssertEqual(libraryNovel, libraryNovel.lastReadSection?.novel)
            XCTAssertEqual(libraryNovel.ncode, "n9669bk")
            XCTAssertEqual(libraryNovel.title, "無職転生　- 異世界行ったら本気だす -")
            XCTAssertEqual(libraryNovel.author, "理不尽な孫の手")
            XCTAssertEqual(libraryNovel.subgenre, 201)
            XCTAssertTrue(libraryNovel.isFavorite)
            XCTAssertEqual(libraryNovel.lastReadSection?.id, 0)
            XCTAssertNil(libraryNovel.lastReadSection?.lastEdit)
            XCTAssertNil(libraryNovel.lastReadSection?.title)
            
            do {
                let count = try self.mockContainer.viewContext.count(for: fetchLibraryNovel)
                XCTAssertEqual(count, 1)
            } catch {
                print("Failed to count LibraryNovel.")
            }

            do {
                let count = try self.mockContainer.viewContext.count(for: fetchLibrarySection)
                XCTAssertEqual(count, 1)
            } catch {
                print("Failed to count LibrarySection.")
            }

            expectation.fulfill()
        }
    }

    func testFetchLibraryDataMatch() {
        let expectation = XCTestExpectation(description: "Fetching Library Data")
        
        mockModel.addFavorite(
            title: "無職転生　- 異世界行ったら本気だす -",
            author: "理不尽な孫の手",
            subgenre: 201
        ) { _ in
            self.mockModel.fetchLibraryData { libraryEntryId in
                guard let libraryEntryId = libraryEntryId, let libraryEntry = try? (
                    self.mockContainer.viewContext.existingObject(
                        with: libraryEntryId
                    ) as? LibraryNovel
                ) else {
                    XCTFail("Failed to retrieve LibraryNovel")
                    return
                }
                XCTAssertEqual(libraryEntry.ncode, "n9669bk")
                XCTAssertEqual(libraryEntry.title, "無職転生　- 異世界行ったら本気だす -")
                XCTAssertEqual(libraryEntry.author, "理不尽な孫の手")
                XCTAssertEqual(libraryEntry.subgenre, 201)
                XCTAssertTrue(libraryEntry.isFavorite)
                XCTAssertEqual(libraryEntry.lastReadSection?.id, 0)
                XCTAssertNil(libraryEntry.lastReadSection?.lastEdit)
                XCTAssertNil(libraryEntry.lastReadSection?.title)
                XCTAssertEqual(libraryEntry.lastReadSection?.novel, libraryEntry)
                
                expectation.fulfill()
            }
        }
    }
    
    func testFetchLibraryDataNoMatch() throws {
        let expectation = XCTestExpectation(description: "Fetching Library Data")
        self.mockModel.fetchLibraryData { libraryEntryId in
            XCTAssertNil(libraryEntryId)
            expectation.fulfill()
        }
    }
}
