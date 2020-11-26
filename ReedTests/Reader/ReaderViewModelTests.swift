//
//  ReaderViewModelTests.swift
//  ReedTests
//
//  Created by Roger Luo on 11/25/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import CoreData
import XCTest
@testable import Reed

class ReaderViewModelTests: XCTestCase {
    lazy var managedObjectModel: NSManagedObjectModel = {
        NSManagedObjectModel.mergedModel(
            from: [Bundle(for: type(of: self))]
        )!
    }()
    var mockContainer: NSPersistentContainer!
    var mockViewModel: ReaderViewModel!

    override func setUp() {
        mockContainer = createMockPersistentContainer(model: managedObjectModel)
        let _ = LibraryNovel.create(
            context: mockContainer.viewContext,
            ncode: "n9669bk",
            title: "無職転生　- 異世界行ったら本気だす -",
            author: "理不尽な孫の手",
            subgenre: 201,
            isFavorite: true
        )
        
        mockViewModel = ReaderViewModel(
            persistentContainer: mockContainer,
            ncode: "n9669bk"
        )
    }

    func testFlippingPages() {
        // Wait until the view model finishes initializing.
        busyAssert(!mockViewModel.pages.isEmpty, timeout: 5)
        
        // Pager automatically calls handlePageFlip once on init, and it should do nothing.
        mockViewModel.handlePageFlip(isInit: true)
        XCTAssertEqual(mockViewModel.curPage, 0)
        XCTAssertEqual(mockViewModel.lastPage, 0)
        
        // flip to the next page
        mockViewModel.curPage += 1
        XCTAssertEqual(mockViewModel.curPage, 1)
        XCTAssertEqual(mockViewModel.lastPage, 0)
        mockViewModel.handlePageFlip(isInit: false)
        XCTAssertEqual(mockViewModel.curPage, 1)
        XCTAssertEqual(mockViewModel.lastPage, 1)
        
        // flip back to the previous page
        mockViewModel.curPage -= 1
        XCTAssertEqual(mockViewModel.curPage, 0)
        XCTAssertEqual(mockViewModel.lastPage, 1)
        mockViewModel.handlePageFlip(isInit: false)
        XCTAssertEqual(mockViewModel.curPage, 0)
        XCTAssertEqual(mockViewModel.lastPage, 0)
        
        // nothing should happen if we try to go back past the very first section
        XCTAssertNil(mockViewModel.section!.prevNcode)
        XCTAssertEqual(mockViewModel.curPage, 0)
        XCTAssertEqual(mockViewModel.lastPage, 0)
 
        // test flipping to the next section
        let numPages = mockViewModel.pages.endIndex
        while mockViewModel.curPage < numPages - 1 {
            mockViewModel.curPage += 1
            mockViewModel.handlePageFlip(isInit: false)
        }
        XCTAssertEqual(mockViewModel.curPage, numPages - 1)
        XCTAssertEqual(mockViewModel.lastPage, numPages - 1)
        mockViewModel.handlePageFlip(isInit: false)
        busyAssert(
            mockViewModel.lastPage == 0 && mockViewModel.curPage == 0,
            timeout: 5
        )
        XCTAssertEqual(mockViewModel.section?.prevNcode, "n9669bk/1")
        XCTAssertEqual(mockViewModel.libraryEntry?.lastReadSection.id, 2)
        
        // test flipping to the previous section
        mockViewModel.handlePageFlip(isInit: false)
        busyAssert(
            mockViewModel.lastPage == mockViewModel.pages.endIndex - 1
                && mockViewModel.curPage == mockViewModel.pages.endIndex - 1,
            timeout: 5
        )
        XCTAssertNil(mockViewModel.section?.prevNcode)
        XCTAssertEqual(mockViewModel.libraryEntry?.lastReadSection.id, 1)
        
        // TODO: nothing should happen if we try to flip to a next section that doesn't exist
    }
}
