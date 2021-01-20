//
//  ReaderViewModelTests.swift
//  ReedTests
//
//  Created by Roger Luo on 11/25/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import CoreData
import XCTest

import SwiftyNarou

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
        let _ = HistoryEntry.create(
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
        print("finished init")
    }

    func testFlippingPages() {
        // Wait until the view model finishes initializing.
        busyAssert(mockViewModel.curPage > -1, timeout: 20)
        
        // Pager automatically calls handlePageFlip once on init, and it should do nothing.
        mockViewModel.handlePageFlip(isInit: true)
        XCTAssertEqual(mockViewModel.curPage, 0)
        
        // flip to the next page
        mockViewModel.curPage += 1
        XCTAssertEqual(mockViewModel.curPage, 1)
        mockViewModel.handlePageFlip(isInit: false)
        XCTAssertEqual(mockViewModel.curPage, 1)
        
        // flip back to the previous page
        mockViewModel.curPage -= 1
        XCTAssertEqual(mockViewModel.curPage, 0)
        mockViewModel.handlePageFlip(isInit: false)
        XCTAssertEqual(mockViewModel.curPage, 0)
        
        // nothing should happen if we try to go back past the very first section
        XCTAssertNil(mockViewModel.section!.prevNcode)
        XCTAssertEqual(mockViewModel.curPage, 0)
        XCTAssertTrue(mockViewModel.pages[0].content != "/n")
        
        // test flipping to the next section
        let numPages = mockViewModel.pages.endIndex
        while mockViewModel.curPage < numPages - 1 {
            mockViewModel.curPage += 1
            mockViewModel.handlePageFlip(isInit: false)
        }
        XCTAssertEqual(mockViewModel.curPage, numPages - 1)
        XCTAssertEqual(mockViewModel.pages[numPages - 1], Page(content: "\n", tokens: []))
        busyAssert(
            mockViewModel.curPage == 1,
            timeout: 20
        )
        XCTAssertEqual(mockViewModel.section?.prevNcode, "n9669bk/1")
        XCTAssertEqual(mockViewModel.historyEntry?.lastReadSection.id, 2)
        
        // test flipping to the previous section
        mockViewModel.curPage = 0
        mockViewModel.handlePageFlip(isInit: false)
        busyAssert(
            mockViewModel.curPage == mockViewModel.pages.endIndex - 2,
            timeout: 20
        )
        XCTAssertNil(mockViewModel.section?.prevNcode)
        XCTAssertEqual(mockViewModel.historyEntry?.lastReadSection.id, 1)
        
        mockViewModel.section = SectionData(
            sectionTitle: "test last section",
            chapterTitle: "last chapter",
            novelTitle: "last novel",
            writer: "last writer",
            content: "last content",
            format: [NSRange: String](),
            prevNcode: nil,
            nextNcode: nil,
            progress: "last progress"
        )
        mockViewModel.pages  = mockViewModel.calcPages(content: "last writer")
        XCTAssertTrue(mockViewModel.pages.endIndex == 1)
    }
}
