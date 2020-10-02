//
//  DictionaryTerm+CoreDataProperties.swift
//  Reed
//
//  Created by Roger Luo on 9/14/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//
//

import Foundation
import CoreData


extension DictionaryTerm {

    @nonobjc class func fetchRequest() -> NSFetchRequest<DictionaryTerm> {
        return NSFetchRequest<DictionaryTerm>(entityName: "DictionaryTerm")
    }

    /// Represents JMDict <keb> tag. Contains one term.
    @NSManaged private var termTerm: String?
    
    /// Represents JMDict <ke_inf> tag. Contains one or more descriptions of unusual aspects of this reading.
    @NSManaged private var termUnusualInfo: [String]?
    
    /// Represents JMDict <ke_pri> tag. Contains zero or more frequency priorities for this term.
    @NSManaged private var termFrequencyPriorities: [String]?
    
    /// Represents JMDict <entry> tag. The entry to which this term belongs.
    @NSManaged var termParentEntry: DictionaryEntry?

    var term: String {
        get { termTerm ?? "" }
        set { termTerm = newValue }
    }
    
    var unusualInfo: [String] {
        get { termUnusualInfo ?? [] }
        set { termUnusualInfo = newValue }
    }
    
    var frequencyPriorities: [String] {
        get { termFrequencyPriorities ?? [] }
        set { termFrequencyPriorities = newValue }
    }
    
    var entry: DictionaryEntry {
        get { termParentEntry! }
        set { termParentEntry = newValue }
    }

}
