//
//  DictionaryParserTestUtils.swift
//  ReedTests
//
//  Created by Roger Luo on 9/18/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import CoreData
import XCTest
@testable import Reed


struct ExpectedEntry {
    let id: Int32
    let terms: [ExpectedTerm]?
    let readings: [ExpectedReading]
    let definitions: [ExpectedDefinition]
    
    init(id: Int32,
         terms: [ExpectedTerm]? = [],
         readings: [ExpectedReading],
         definitions: [ExpectedDefinition]
    ) {
        self.id = id
        self.terms = terms
        self.readings = readings
        self.definitions = definitions
    }
}

struct ExpectedTerm {
    let term: String
    let unusualInfo: [String]?
    let frequencyPriorities: [String]?
    
    init(
        term: String,
        unusualInfo: [String]? = [],
        frequencyPriorities: [String]? = []
    ) {
        self.term = term
        self.unusualInfo = unusualInfo
        self.frequencyPriorities = frequencyPriorities
    }
}

struct ExpectedReading {
    let reading: String
    let terms: [String]?
    let unusualInfo: [String]?
    let frequencyPriorities: [String]?
    
    init(
        reading: String,
        terms: [String]? = [],
        unusualInfo: [String]? = [],
        frequencyPriorities: [String]? = []
    ) {
        self.reading = reading
        self.terms = terms
        self.unusualInfo = unusualInfo
        self.frequencyPriorities = frequencyPriorities
    }
}

struct ExpectedDefinition {
    let glosses: [String]
    let antonyms: [String]?
    let crossReferences: [String]?
    let dialects: [String]?
    let jargonUses: [String]?
    let languageSources: [ExpectedLanguageSource]?
    let miscellanea: [String]?
    let partsOfSpeech: [String]?
    let specificLexemes: [String]?
    let usageInfo: [String]?
    
    init(
        glosses: [String],
        antonyms: [String]? = [],
        crossReferences: [String]? = [],
        dialects: [String]? = [],
        jargonUses: [String]? = [],
        languageSources: [ExpectedLanguageSource]? = [],
        miscellanea: [String]? = [],
        partsOfSpeech: [String]? = [],
        specificLexemes: [String]? = [],
        usageInfo: [String]? = []
    ) {
        self.glosses = glosses
        self.antonyms = antonyms
        self.crossReferences = crossReferences
        self.dialects = dialects
        self.jargonUses = jargonUses
        self.languageSources = languageSources
        self.miscellanea = miscellanea
        self.partsOfSpeech = partsOfSpeech
        self.specificLexemes = specificLexemes
        self.usageInfo = usageInfo
    }
}

struct ExpectedLanguageSource {
    let isWasei: Bool
    let language: String?
    let meaning: String?
    
    init(
        isWasei: Bool,
        language: String? = "",
        meaning: String? = ""
    ) {
        self.isWasei = isWasei
        self.language = language
        self.meaning = meaning
    }
}

func formatTestData(_ testData: String) -> Data {
    return testData
        .replacingOccurrences(of: "    ", with: "")
        .replacingOccurrences(of: "\n", with: "")
        .data(using: .utf8)!
}

func testParse(mockParser: DictionaryParser, testData: Data, expected: ExpectedEntry) {
    mockParser.parseAndLoad(dictionaryData: testData)
    
    let res = mockParser.storageManager.fetchAll()[0]
    validateDictionaryEntry(created: res, expected: expected)
}

/**
 Field-wise validation of created dictionary entry.
 This is necessary because equality for NSManagedObject is defined as
 equality of location in memory rather than field-wise equality.
*/
func validateDictionaryEntry(created: DictionaryEntry, expected: ExpectedEntry) {
    XCTAssertEqual(created.id, expected.id)
    for (i, reading) in created.readings.enumerated() {
        validateDictionaryReading(created: reading, expected: expected.readings[i])
        XCTAssertEqual(
            reading.entry,
            created,
            "DictionaryEntryReading child does not reference current DictionaryEntry as parent in `entry` property."
        )
    }
    for (i, term) in created.terms.enumerated() {
        validateDictionaryTerm(created: term, expected: expected.terms![i])
        XCTAssertEqual(
            term.entry,
            created,
            "DictionaryEntryTerm child does not reference current DictionaryEntry as parent in `entry` property."
        )
    }
    
    for (i, definition) in created.definitions.enumerated() {
        validateDictionaryDefinition(created: definition, expected: expected.definitions[i])
        XCTAssertEqual(
            definition.entry,
            created,
            "DictionaryEntryDefinition child does not reference current DictionaryEntry as parent in `entry` property."
        )
    }
}

func validateDictionaryReading(created: DictionaryReading, expected: ExpectedReading) {
    XCTAssertEqual(
        created.reading,
        expected.reading,
        "DictionaryEntryReading does not have the correct value for property `reading`."
    )
    XCTAssertEqual(
        created.terms,
        expected.terms,
        "DictionaryEntryReading does not have the correct value for property `terms`."
    )
    XCTAssertEqual(
        created.unusualInfo,
        expected.unusualInfo,
        "DictionaryEntryReading does not have the correct value for property `unusualInfo`."
    )
    XCTAssertEqual(
        created.frequencyPriorities,
        expected.frequencyPriorities,
        "DictionaryEntryReading does not have the correct value for property `frequencyPriorities`."
    )
}

func validateDictionaryTerm(created: DictionaryTerm, expected: ExpectedTerm) {
    XCTAssertEqual(
        created.term,
        expected.term,
        "DictionaryEntryTerm does not have the correct value for property `term`."
    )
    XCTAssertEqual(
        created.unusualInfo,
        expected.unusualInfo,
        "DictionaryEntryTerm does not have the correct value for property `unusualInfo`."
    )
    XCTAssertEqual(
        created.frequencyPriorities,
        expected.frequencyPriorities,
        "DictionaryEntryTerm does not have the correct value for property `frequencyPriorities`."
    )
}

func validateDictionaryDefinition(created: DictionaryDefinition, expected: ExpectedDefinition) {
    XCTAssertEqual(
        created.glosses,
        expected.glosses,
        "DictionaryEntryDefinition does not have the correct value for property `glosses`."
    )
    XCTAssertEqual(
        created.partsOfSpeech,
        expected.partsOfSpeech,
        "DictionaryEntryDefinition does not have the correct value for property `partsOfSpeech`."
    )
    XCTAssertEqual(
        created.specificLexemes,
        expected.specificLexemes,
        "DictionaryEntryDefinition does not have the correct value for property `specificLexemes`."
    )
    XCTAssertEqual(
        created.dialects,
        expected.dialects,
        "DictionaryEntryDefinition does not have the correct value for property `dialects`."
    )
    XCTAssertEqual(
        created.jargonUses,
        expected.jargonUses,
        "DictionaryEntryDefinition does not have the correct value for property `jargonUses`."
    )
    XCTAssertEqual(
        created.miscellanea,
        expected.miscellanea,
        "DictionaryEntryDefinition does not have the correct value for property `miscellanea`."
    )
    XCTAssertEqual(
        created.crossReferences,
        expected.crossReferences,
        "DictionaryEntryDefinition does not have the correct value for property `crossReferences`."
    )
    
    for (i, lsource) in created.languageSources.enumerated() {
        validateDictionaryLanguageSource(created: lsource, expected: expected.languageSources![i])
        XCTAssertEqual(
            lsource.parentDefinition,
            created,
            "DictionaryLanguageSource child does not reference current DictionaryDefinition as parent in `parentDefinition` property."
        )
    }
 
}

func validateDictionaryLanguageSource(created: DictionaryLanguageSource, expected: ExpectedLanguageSource) {
    XCTAssertEqual(
        created.isWasei,
        expected.isWasei,
        "DictionaryEntryDefinition does not have the correct value for property `isWasei`."
    )
    XCTAssertEqual(
        created.language,
        expected.language,
        "DictionaryEntryDefinition does not have the correct value for property `language`."
    )
    XCTAssertEqual(
        created.meaning,
        expected.meaning,
        "DictionaryEntryDefinition does not have the correct value for property `meaning`."
    )
}
