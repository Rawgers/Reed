//
//  DefinitionModalViewModel.swift
//  Reed
//
//  Created by Hugo Zhan on 11/3/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import SwiftUI

class DefinitionModalViewModel: ObservableObject {
    @Published var content = ""
    let dictionaryFetcher = DictionaryFetcher()
    
    func generateContent(from tappedWord: String) {
        let entries = dictionaryFetcher.fetchEntries(of: tappedWord)
        var content = tappedWord
        var count = 1
        for entry in entries {
            content += "\n\(count)."
            if !entry.terms.isEmpty {
                content += "\nTerms: \n"
                for term in entry.terms {
                    content += term.term + ", "
                }
                content.removeLast(2)
            }
            content += "\nReadings:"
            for reading in entry.readings {
                content += "\n\u{2022}" + reading.reading + ": "
                for term in reading.terms {
                    content += term + ", "
                }
                content.removeLast(2)
            }
            content += "\nDefintions:"
            for sense in entry.definitions {
                content += "\n\u{2022}"
                for gloss in sense.glosses {
                    content += gloss + ", "
                }
                content.removeLast(2)
                let specibool = !sense.specificLexemes.isEmpty
                if specibool {
                    content += "(only for: "
                }
                for specific in sense.specificLexemes {
                    content += specific + ", "
                }
                if specibool {
                    content.removeLast(2)
                    content += ")"
                }
            }
            count += 1
        }
        self.content = content
    }
}
