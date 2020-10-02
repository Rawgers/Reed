//
//  DictionaryLanguageSource+CoreDataProperties.swift
//  Reed
//
//  Created by Roger Luo on 9/20/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//
//

import Foundation
import CoreData


extension DictionaryLanguageSource {

    @nonobjc class func fetchRequest() -> NSFetchRequest<DictionaryLanguageSource> {
        return NSFetchRequest<DictionaryLanguageSource>(entityName: "DictionaryLanguageSource")
    }

    /// Represents JMDict `ls_wasei` attribute. Is true when the attribute is `y`.
    @NSManaged private var lsourceIsWasei: Bool
    
    /// Represents JMDict `xml:lang` attribute. Contains an abbreviation of the source language.
    @NSManaged private var lsourceLanguage: String?
    
    /// Represents JMDict <lsource> content. Cotains the meaning of the <sense> in its original language.
    @NSManaged private var lsourceMeaning: String?
    
    /// The <sense> to which this <lsource> belongs.
    @NSManaged private var lsourceParentDefinition: DictionaryDefinition?

    var isWasei: Bool {
        get { lsourceIsWasei }
        set { lsourceIsWasei = newValue }
    }
    
    var language: String {
        get { lsourceLanguage ?? "" }
        set { lsourceLanguage = newValue }
    }
    
    var meaning: String {
        get { lsourceMeaning ?? "" }
        set { lsourceMeaning = newValue }
    }
    
    var parentDefinition: DictionaryDefinition {
        get { lsourceParentDefinition! }
        set { lsourceParentDefinition = newValue }
    }
}
