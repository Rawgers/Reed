//
//  NovelDetailsViewModelTests.swift
//  ReedTests
//
//  Created by Roger Luo on 11/25/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import CoreData
import XCTest
@testable import Reed

class NovelDetailsViewModelTest: XCTestCase {
    lazy var managedObjectModel: NSManagedObjectModel = {
        NSManagedObjectModel.mergedModel(
            from: [Bundle(for: type(of: self))]
        )!
    }()
    var mockContainer: NSPersistentContainer!
    var mockViewModel: NovelDetailsViewModel!

    override func setUp() {
        mockContainer = createMockPersistentContainer(model: managedObjectModel)
        mockViewModel = NovelDetailsViewModel(
            persistentContainer: mockContainer,
            ncode: "n9669bk"
        )
    }

    func testToggleFavorite() {
        let fetchRequest: NSFetchRequest<HistoryEntry> = HistoryEntry.fetchRequest()
        do {
            let numEntries = try mockContainer.viewContext.count(for: fetchRequest)
            XCTAssertEqual(
                numEntries, 0,
                "There should be no HistoryEntry entries at the start of this test."
            )
        } catch {
            XCTFail("Failed to count CoreData entries.")
        }
        
        // First call to toggleFavorite to create a new HistoryEntry
        mockViewModel.toggleFavorite()
        busyAssert(
            mockViewModel.isFavorite == true,
            timeout: 1,
            message: "The view model should set its own isFavorite property to true after creating a new entry."
        )
        do {
            let numEntries = try mockContainer.viewContext.count(for: fetchRequest)
            XCTAssertEqual(
                numEntries, 1,
                "Toggling the favorite button when the novel does not exist in the reading history creates a new HistoryEntry."
            )
        } catch {
            XCTFail("Failed to count CoreData entries.")
        }
        XCTAssertNotNil(
            mockViewModel.historyEntry,
            "The view model should have reference to the HistoryEntry created by toggleFavorite."
        )
        XCTAssertTrue(
            mockViewModel.historyEntry!.isFavorite,
            "When toggleFavorite creates a new HistoryEntry it should automatically be favorited."
        )
        
        // Second call to toggleFavorite to un-favorite the entry.
        mockViewModel.toggleFavorite()
        busyAssert(
            mockViewModel.isFavorite == false,
            timeout: 1,
            message: "The view model's isFavorite property should reflect the false state of its historyEntry."
        )
        XCTAssertFalse(
            mockViewModel.historyEntry!.isFavorite,
            "This call should un-favorite the HistoryEntry."
        )
        
        // Third call to toggleFavorite should re-favorite the entry.
        mockViewModel.toggleFavorite()
        busyAssert(
            mockViewModel.isFavorite == true,
            timeout: 1,
            message: "The view model's isFavorite property should reflect the true state of its historyEntry."
        )
        XCTAssertTrue(
            mockViewModel.historyEntry!.isFavorite,
            "This call should un-favorite the HistoryEntry."
        )
        
        do {
            let numEntries = try mockContainer.viewContext.count(for: fetchRequest)
            XCTAssertEqual(
                numEntries, 1,
                "toggleFavorite should have only created one new HistoryEntry."
            )
        } catch {
            XCTFail("Failed to count CoreData entries.")
        }
    }
}
