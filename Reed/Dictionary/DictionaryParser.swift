//
//  DictionaryParser.swift
//  Reed
//
//  Created by Roger Luo on 9/10/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import CoreData
import Foundation
import SwiftUI

import Gzip
import SwiftyJSON


enum DictionaryParserError: Error {
    case decompressFailure
    case invalidContents
    case incorrectDataFormat
    case missingDictionary
}

class DictionaryParser: NSObject {
    
    var storageManager: DictionaryStorageManager!
    lazy var context: NSManagedObjectContext = {
        return storageManager.backgroundContext
    }()
    
    var terms: [String]!
    var partsOfSpeech: [String]!
    
    init(storageManager: DictionaryStorageManager?) {
        if storageManager != nil {
            self.storageManager = storageManager
        }
        super.init()
    }
    
    convenience override init() {
        self.init(storageManager: nil)
        storageManager = DictionaryStorageManager()
    }
    
    func readInDictionaryData() throws -> Data {
        guard let dictionaryPath = Bundle.main.path(forResource: "JMdict_e.json", ofType: "gz") else {
            throw DictionaryParserError.missingDictionary
        }
        guard let compressedContents = FileManager().contents(atPath: dictionaryPath) else {
            throw DictionaryParserError.invalidContents
        }
        if !compressedContents.isGzipped {
            throw DictionaryParserError.incorrectDataFormat
        }
        if let decompressedData = try? compressedContents.gunzipped() {
            return decompressedData
        } else {
            throw DictionaryParserError.decompressFailure
        }
    }
    
    func parseAndLoad(dictionaryData: Data) {
        let dictionary = try! JSON(data: dictionaryData)
        parse(dictionary)
        storageManager.save()
    }
    
    private func parse(_ dictionary: JSON) {
        for (i, entry) in dictionary {
            if Int(i)! % 1000 == 0 {
                storageManager.save()
            }
            terms = [String]()
            partsOfSpeech = [String]()
            
            let parsedEntry = DictionaryEntry(using: context)
            parsedEntry.id = Int32(entry["ent_seq"][0].stringValue)!
            
            parseTerms(entry["k_ele"], parentEntry: parsedEntry)
            parseReadings(entry["r_ele"], parentEntry: parsedEntry)
            parseDefinitions(entry["sense"], parentEntry: parsedEntry)
        }
        
        NotificationCenter.default.post(name: .didFinishLoadingDictionary, object: nil)
    }
    
    private func parseTerms(_ kEles: JSON, parentEntry: DictionaryEntry) {
        for (_, term) in kEles {
            let parsedTerm = DictionaryTerm(using: context)
            parsedTerm.term = term["keb"][0].stringValue
            parsedTerm.frequencyPriorities = term["ke_pri"].arrayValue
                .map { $0.stringValue }
            parsedTerm.unusualInfo = term["ke_inf"].arrayValue
                .map { $0.stringValue }
            
            parentEntry.addToEntryTerms(parsedTerm)
            terms.append(parsedTerm.term)
        }
    }
    
    private func parseReadings(_ rEles: JSON, parentEntry: DictionaryEntry) {
        for (_, reading) in rEles {
            let parsedReading = DictionaryReading(using: context)
            parsedReading.reading = reading["reb"][0].stringValue
            let specificTerms = reading["re_restr"].arrayValue
                .map { $0.stringValue }
            parsedReading.terms = specificTerms.isEmpty
                ? terms
                : specificTerms
            parsedReading.unusualInfo = reading["re_inf"].arrayValue
                .map { $0.stringValue }
            parsedReading.frequencyPriorities = reading["re_pri"].arrayValue
                .map { $0.stringValue }
            
            parentEntry.addToEntryReadings(parsedReading)
        }
    }
    
    private func parseDefinitions(_ senses: JSON, parentEntry: DictionaryEntry) {
        for (_, definition) in senses {
            let parsedDefinition = DictionaryDefinition(using: context)
            parsedDefinition.glosses = definition["gloss"].arrayValue
                .map { ($0.stringValue == "" ? $0["_"] : $0).stringValue }
            let parsedPos = definition["pos"].arrayValue
                .map { $0.stringValue }
            if !parsedPos.isEmpty {
                partsOfSpeech = parsedPos
            }
            parsedDefinition.partsOfSpeech = partsOfSpeech.isEmpty
                ? parsedPos
                : partsOfSpeech
            
            var specificLexemes = definition["stagr"].arrayValue
                .map { $0.stringValue }
            specificLexemes.append(
                contentsOf: definition["stagk"].arrayValue
                    .map { $0.stringValue }
            )
            parsedDefinition.specificLexemes = specificLexemes
            
            parsedDefinition.antonyms = definition["ant"].arrayValue
                .map { $0.stringValue }
            parsedDefinition.crossReferences = definition["xref"].arrayValue
                .map { $0.stringValue }
            parsedDefinition.dialects = definition["dial"].arrayValue
                .map { $0.stringValue }
            parsedDefinition.jargonUses = definition["field"].arrayValue
                .map { $0.stringValue }
            parsedDefinition.miscellanea = definition["misc"].arrayValue
                .map { $0.stringValue }
            
            parseLanguageSources(definition["lsource"], parentDefinition: parsedDefinition)
            parentEntry.addToEntryDefinitions(parsedDefinition)
        }
    }
    
    private func parseLanguageSources(_ lsources: JSON, parentDefinition: DictionaryDefinition) {
        for (_, lsource) in lsources {
            
            let parsedLanguageSource = DictionaryLanguageSource(using: context)
            parsedLanguageSource.isWasei = lsource["$"]["ls_wasei"].stringValue == "y"
            parsedLanguageSource.language = lsource["$"]["xml:lang"].stringValue
            parsedLanguageSource.meaning = lsource["_"].stringValue
            
            parentDefinition.addToDefLanguageSources(parsedLanguageSource)
        }
    }
    
}
