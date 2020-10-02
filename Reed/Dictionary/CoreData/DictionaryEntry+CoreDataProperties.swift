//
//  DictionaryEntry+CoreDataProperties.swift
//  Reed
//
//  Created by Roger Luo on 9/14/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//
//

import Foundation
import CoreData


extension DictionaryEntry {

    @nonobjc class func fetchRequest() -> NSFetchRequest<DictionaryEntry> {
        return NSFetchRequest<DictionaryEntry>(entityName: "DictionaryEntry")
    }

    /// Represents JMDict <ent_seq> tag. Uniquely identifies each <entry> with a number starting from 1,000,000.
    @NSManaged var entryId: Int32
    
    /// Represents JMDict <r_ele> tag. Contains one or more DictionaryReading objects.
    @NSManaged private var entryReadings: NSOrderedSet?
    
    /// Represents JMDict <k_ele> tag. Contains zero or more DictionaryTerm objects.
    @NSManaged private var entryTerms: NSOrderedSet?
    
    /// Represents JMDict <sense> tag. Contains one or more DictionaryDefinition objects.
    @NSManaged private var entryDefinitions: NSOrderedSet?
    
    var id: Int32 {
        get { entryId }
        set { entryId = newValue }
    }
    
    var readings: [DictionaryReading] {
        get { entryReadings?.array as? [DictionaryReading] ?? [] }
        set { entryReadings = NSOrderedSet(object: newValue) }
    }
    
    var terms: [DictionaryTerm] {
        get { entryReadings?.array as? [DictionaryTerm] ?? [] }
        set { entryTerms = NSOrderedSet(object: newValue) }
    }

    var definitions: [DictionaryDefinition] {
        get { entryDefinitions?.array as? [DictionaryDefinition] ?? [] }
        set { entryDefinitions = NSOrderedSet(object: newValue) }
    }
    
}

// MARK: Generated accessors for entryDefinitions
extension DictionaryEntry {

    @objc(insertObject:inEntryDefinitionsAtIndex:)
    @NSManaged public func insertIntoEntryDefinitions(_ value: DictionaryDefinition, at idx: Int)

    @objc(removeObjectFromEntryDefinitionsAtIndex:)
    @NSManaged public func removeFromEntryDefinitions(at idx: Int)

    @objc(insertEntryDefinitions:atIndexes:)
    @NSManaged public func insertIntoEntryDefinitions(_ values: [DictionaryDefinition], at indexes: NSIndexSet)

    @objc(removeEntryDefinitionsAtIndexes:)
    @NSManaged public func removeFromEntryDefinitions(at indexes: NSIndexSet)

    @objc(replaceObjectInEntryDefinitionsAtIndex:withObject:)
    @NSManaged public func replaceEntryDefinitions(at idx: Int, with value: DictionaryDefinition)

    @objc(replaceEntryDefinitionsAtIndexes:withEntryDefinitions:)
    @NSManaged public func replaceEntryDefinitions(at indexes: NSIndexSet, with values: [DictionaryDefinition])

    @objc(addEntryDefinitionsObject:)
    @NSManaged public func addToEntryDefinitions(_ value: DictionaryDefinition)

    @objc(removeEntryDefinitionsObject:)
    @NSManaged public func removeFromEntryDefinitions(_ value: DictionaryDefinition)

    @objc(addEntryDefinitions:)
    @NSManaged public func addToEntryDefinitions(_ values: NSOrderedSet)

    @objc(removeEntryDefinitions:)
    @NSManaged public func removeFromEntryDefinitions(_ values: NSOrderedSet)

}

// MARK: Generated accessors for entryReadings
extension DictionaryEntry {

    @objc(insertObject:inEntryReadingsAtIndex:)
    @NSManaged public func insertIntoEntryReadings(_ value: DictionaryReading, at idx: Int)

    @objc(removeObjectFromEntryReadingsAtIndex:)
    @NSManaged public func removeFromEntryReadings(at idx: Int)

    @objc(insertEntryReadings:atIndexes:)
    @NSManaged public func insertIntoEntryReadings(_ values: [DictionaryReading], at indexes: NSIndexSet)

    @objc(removeEntryReadingsAtIndexes:)
    @NSManaged public func removeFromEntryReadings(at indexes: NSIndexSet)

    @objc(replaceObjectInEntryReadingsAtIndex:withObject:)
    @NSManaged public func replaceEntryReadings(at idx: Int, with value: DictionaryReading)

    @objc(replaceEntryReadingsAtIndexes:withEntryReadings:)
    @NSManaged public func replaceEntryReadings(at indexes: NSIndexSet, with values: [DictionaryReading])

    @objc(addEntryReadingsObject:)
    @NSManaged public func addToEntryReadings(_ value: DictionaryReading)

    @objc(removeEntryReadingsObject:)
    @NSManaged public func removeFromEntryReadings(_ value: DictionaryReading)

    @objc(addEntryReadings:)
    @NSManaged public func addToEntryReadings(_ values: NSOrderedSet)

    @objc(removeEntryReadings:)
    @NSManaged public func removeFromEntryReadings(_ values: NSOrderedSet)

}

// MARK: Generated accessors for entryTerms
extension DictionaryEntry {

    @objc(insertObject:inEntryTermsAtIndex:)
    @NSManaged public func insertIntoEntryTerms(_ value: DictionaryTerm, at idx: Int)

    @objc(removeObjectFromEntryTermsAtIndex:)
    @NSManaged public func removeFromEntryTerms(at idx: Int)

    @objc(insertEntryTerms:atIndexes:)
    @NSManaged public func insertIntoEntryTerms(_ values: [DictionaryTerm], at indexes: NSIndexSet)

    @objc(removeEntryTermsAtIndexes:)
    @NSManaged public func removeFromEntryTerms(at indexes: NSIndexSet)

    @objc(replaceObjectInEntryTermsAtIndex:withObject:)
    @NSManaged public func replaceEntryTerms(at idx: Int, with value: DictionaryTerm)

    @objc(replaceEntryTermsAtIndexes:withEntryTerms:)
    @NSManaged public func replaceEntryTerms(at indexes: NSIndexSet, with values: [DictionaryTerm])

    @objc(addEntryTermsObject:)
    @NSManaged public func addToEntryTerms(_ value: DictionaryTerm)

    @objc(removeEntryTermsObject:)
    @NSManaged public func removeFromEntryTerms(_ value: DictionaryTerm)

    @objc(addEntryTerms:)
    @NSManaged public func addToEntryTerms(_ values: NSOrderedSet)

    @objc(removeEntryTerms:)
    @NSManaged public func removeFromEntryTerms(_ values: NSOrderedSet)

}
