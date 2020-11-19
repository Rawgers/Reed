//
//  Tokenizer.swift
//  Reed
//
//  Created by Shiori Yamashita on 2020/11/04.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

struct Token {
    let surface: String
    let dictionaryEntry: DictionaryEntry?
    let mecabWordNodes: [MecabWordNode]
    let deinflectionResult: DeinflectionResult?
    let range: (Int, Int)
}

class Tokenizer {
    let MAXIMUM_CONCATENATION = 4
    
    let dictionaryFetcher: DictionaryFetcher
    let mecabWrapper: MecabWrapper
    let deinflector: Deinflector
    
    init() {
        dictionaryFetcher = DictionaryFetcher()
        mecabWrapper = MecabWrapper()
        deinflector = Deinflector()
    }
    
    func tokenize(_ text: String) -> [Token] {
        let mecabWordNodes = mecabWrapper.tokenize(text)
        let phrases = separateIntoPhrases(nodes: mecabWordNodes)
        var tokens = [Token]()
        for phrase in phrases {
            tokens.append(contentsOf: tokenizeSinglePhrase(nodes: phrase))
        }
        return tokens
    }
    
    func separateIntoPhrases(nodes: [MecabWordNode]) -> [[MecabWordNode]] {
        var phrases = [[MecabWordNode]]()
        var isPreviousNodePhraseBoundary = true
        for node in nodes {
            if node.canMakeCompoundWord {
                if isPreviousNodePhraseBoundary {
                    phrases.append([node])
                } else {
                    phrases[phrases.count - 1].append(node)
                }
                isPreviousNodePhraseBoundary = false
            } else {
                phrases.append([node])
                isPreviousNodePhraseBoundary = true
            }
        }
        return phrases
    }
    
    func tokenizeSinglePhrase(nodes: [MecabWordNode]) -> [Token] {
        var tokens = [Token]()
        
        var startIndex = 0
        let tokenCount = nodes.endIndex
        while startIndex < tokenCount {
            let firstNode = nodes[startIndex]
            if !firstNode.canStartCompoundWord {
                let (dictionaryEntry, deinflectionResult) = fetchDictionaryEntry(
                    text: firstNode.surface
                )
                tokens.append(Token(
                    surface: firstNode.surface,
                    dictionaryEntry: dictionaryEntry,
                    mecabWordNodes: [firstNode],
                    deinflectionResult: deinflectionResult,
                    range: firstNode.range
                ))
                startIndex += 1
                continue
            }
            for concatenationCount in stride(from: MAXIMUM_CONCATENATION, to: 0, by: -1) {
                let endIndex = min(startIndex + concatenationCount, tokenCount)
                let lastNode = nodes[endIndex - 1]
                
                if !lastNode.canEndCompoundWord && concatenationCount > 1 { continue }
                
                let nodesToBeConcatenated = Array(nodes[startIndex ..< endIndex])
                let concatenatedToken = MecabWordNode.concatenate(nodesToBeConcatenated)
                let (dictionaryEntry, deinflectionResult) = fetchDictionaryEntry(
                    text: concatenatedToken.surface
                )
                if concatenationCount == 1 || dictionaryEntry != nil {
                    tokens.append(Token(
                        surface: concatenatedToken.surface,
                        dictionaryEntry: dictionaryEntry,
                        mecabWordNodes: nodesToBeConcatenated,
                        deinflectionResult: deinflectionResult,
                        range: concatenatedToken.range
                    ))
                    startIndex += concatenationCount
                    break
                }
            }
        }
        
        return tokens
    }

    // TODO: The entry with least deinflection and most characters should be picked
    func fetchDictionaryEntry(text: String) -> (DictionaryEntry?, DeinflectionResult?) {
        var entry: DictionaryEntry?
        var deinflectionResult: DeinflectionResult?
        
        let deinflectionResults = deinflector.deinflect(text: text)
        for result in deinflectionResults {
            let entries = dictionaryFetcher.fetchEntries(of: result.text)
            if entries.isEmpty { continue }
            let bestEntry = entries.first
            if entry == nil {
                entry = bestEntry
                deinflectionResult = result
            } else {
                entry = bestEntry
                deinflectionResult = result
            }
        }
        
        return (entry, deinflectionResult)
    }
}
