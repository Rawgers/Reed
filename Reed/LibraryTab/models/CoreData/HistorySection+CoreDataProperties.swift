//
//  HistorySection+CoreDataProperties.swift
//  
//
//  Created by Roger Luo on 11/5/20.
//
//

import Foundation
import CoreData

extension HistorySection {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HistorySection> {
        return NSFetchRequest<HistorySection>(entityName: "HistorySection")
    }

    @NSManaged private var sectionId: Int64
    @NSManaged private var sectionTitle: String?
    @NSManaged private var sectionLastEdit: Date?
    @NSManaged private var sectionNovel: HistoryEntry?

    var id: Int {
        get { Int(sectionId) }
        set { sectionId = Int64(newValue) }
    }
    
    var title: String {
        get { sectionTitle ?? "" }
        set { sectionTitle = newValue }
    }
    
    var lastEdit: Date? {
        get { sectionLastEdit }
        set { sectionLastEdit = newValue }
    }
    
    var novel: HistoryEntry {
        get { sectionNovel! }
        set { sectionNovel = newValue }
    }
}
