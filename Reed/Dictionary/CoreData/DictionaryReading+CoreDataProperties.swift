//
//  DictionaryReading+CoreDataProperties.swift
//  Reed
//
//  Created by Roger Luo on 9/14/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//
//

import Foundation
import CoreData


extension DictionaryReading {

    @nonobjc class func fetchRequest() -> NSFetchRequest<DictionaryReading> {
        return NSFetchRequest<DictionaryReading>(entityName: "DictionaryReading")
    }

    /// Represents JMDict <reb> tag. Contains one reading.
    @NSManaged private var readingReading: String?
    
    /// Contains all terms to which this reading applies.
    @NSManaged private var readingTerms: [String]?
    
    /// Represents JMDict <re_inf> tag. Contains one or more descriptions of unusual aspects of this reading.
    @NSManaged private var readingUnusualInfo: [String]?
    
    /// Represents JMDict <re_pri> tag. Contains zero or more frequency priorities for this reading.
    @NSManaged private var readingFrequencyPriorities: [String]?
    
    /// Represents JMDict <entry> tag. The entry to which this reading belongs.
    @NSManaged var readingParentEntry: DictionaryEntry?
    
    var reading: String {
        get { readingReading ?? "" }
        set { readingReading = newValue }
    }
    
    var terms: [String] {
        get { readingTerms ?? [] }
        set { readingTerms = newValue }
    }
    
    var unusualInfo: [String] {
        get { readingUnusualInfo ?? [] }
        set { readingUnusualInfo = newValue }
    }
    
    var frequencyPriorities: [String] {
        get { readingFrequencyPriorities ?? [] }
        set { readingFrequencyPriorities = newValue }
    }
    
    var entry: DictionaryEntry {
        get { readingParentEntry! }
        set { readingParentEntry = newValue }
    }
    
}
