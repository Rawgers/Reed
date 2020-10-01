//
//  DictionaryDefinition+CoreDataProperties.swift
//  Reed
//
//  Created by Roger Luo on 9/20/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//
//

import Foundation
import CoreData


extension DictionaryDefinition {

    @nonobjc class func fetchRequest() -> NSFetchRequest<DictionaryDefinition> {
        return NSFetchRequest<DictionaryDefinition>(entityName: "DictionaryDefinition")
    }
    
    /// Represents JMDict <ant> tag. Contains one or more "direct" antonyms of this definition.
    @NSManaged private var defAntonyms: [String]?
    
    /// Represents JMDict <xref> tag. References one or more definitions in other entries that are strongly related to this definition.
    @NSManaged private var defCrossReferences: [String]?
    
    /// Represents JMDict <dial> tag. Contains one or more internal references representing dialects that use this definition.
    @NSManaged private var defDialects: [String]?
    
    /// Represents JMDict <gloss> tag. Contains one or more definition values.
    @NSManaged private var defGlosses: [String]?
    
    /// Represents JMDict <field> tag. Describes special fields that use this definition.
    @NSManaged private var defJargonUses: [String]?
    
    /// Represents JMDict <lsource> tag. Describes the languages from which this definition was derived.
    @NSManaged private var defLanguageSources: NSOrderedSet?
    
    /// Represents JMDict <misc> tag. May contain any other relevant to the definition.
    @NSManaged private var defMiscellanea: [String]?
    
    /// Represents JMDict <pos> tag. Contains one or more internal references representing valid parts of speech.
    @NSManaged private var defPartsOfSpeech: [String]?
    
    /// Represents JMDict <stagk> and tags. Describes one or more specific terms or readings that apply to this definition.
    @NSManaged private var defSpecificLexemes: [String]?
    
    /// Represents JMDict <s_inf> tag. May contain usage information about this definition.
    @NSManaged private var defUsageInfo: [String]?
    
    /// Represents JMDict <entry> tag. The entry to which this definition belongs.
    @NSManaged private var defParentEntry: DictionaryEntry?

    var glosses: [String] {
        get { defGlosses ?? [] }
        set { defGlosses = newValue }
    }
    
    var specificLexemes: [String] {
        get { defSpecificLexemes ?? [] }
        set { defSpecificLexemes = newValue }
    }
    
    var partsOfSpeech: [String] {
        get { defPartsOfSpeech ?? [] }
        set { defPartsOfSpeech = newValue }
    }
    
    var dialects: [String] {
        get { defDialects ?? [] }
        set { defDialects = newValue }
    }
    
    var jargonUses: [String] {
        get { defJargonUses ?? [] }
        set { defJargonUses = newValue }
    }
    
    var languageSources: [DictionaryLanguageSource] {
        get { defLanguageSources?.array as? [DictionaryLanguageSource] ?? [] }
        set { defLanguageSources = NSOrderedSet(object: newValue) }
    }
    
    var miscellanea: [String] {
        get { defMiscellanea ?? [] }
        set { defMiscellanea = newValue }
    }
    
    var usageInfo: [String] {
        get { defUsageInfo ?? [] }
        set { defUsageInfo = newValue }
    }
    
    var antonyms: [String] {
        get { defAntonyms ?? [] }
        set { defAntonyms = newValue }
    }
    
    var crossReferences: [String] {
        get { defCrossReferences ?? [] }
        set { defCrossReferences = newValue }
    }
    
    var entry: DictionaryEntry {
        get { defParentEntry! }
        set { defParentEntry = newValue }
    }


}

// MARK: Generated accessors for defLanguageSources
extension DictionaryDefinition {

    @objc(insertObject:inDefLanguageSourcesAtIndex:)
    @NSManaged public func insertIntoDefLanguageSources(_ value: DictionaryLanguageSource, at idx: Int)

    @objc(removeObjectFromDefLanguageSourcesAtIndex:)
    @NSManaged public func removeFromDefLanguageSources(at idx: Int)

    @objc(insertDefLanguageSources:atIndexes:)
    @NSManaged public func insertIntoDefLanguageSources(_ values: [DictionaryLanguageSource], at indexes: NSIndexSet)

    @objc(removeDefLanguageSourcesAtIndexes:)
    @NSManaged public func removeFromDefLanguageSources(at indexes: NSIndexSet)

    @objc(replaceObjectInDefLanguageSourcesAtIndex:withObject:)
    @NSManaged public func replaceDefLanguageSources(at idx: Int, with value: DictionaryLanguageSource)

    @objc(replaceDefLanguageSourcesAtIndexes:withDefLanguageSources:)
    @NSManaged public func replaceDefLanguageSources(at indexes: NSIndexSet, with values: [DictionaryLanguageSource])

    @objc(addDefLanguageSourcesObject:)
    @NSManaged public func addToDefLanguageSources(_ value: DictionaryLanguageSource)

    @objc(removeDefLanguageSourcesObject:)
    @NSManaged public func removeFromDefLanguageSources(_ value: DictionaryLanguageSource)

    @objc(addDefLanguageSources:)
    @NSManaged public func addToDefLanguageSources(_ values: NSOrderedSet)

    @objc(removeDefLanguageSources:)
    @NSManaged public func removeFromDefLanguageSources(_ values: NSOrderedSet)

}
