//
//  Tokenizer.swift
//  Reed
//
//  Created by Shiori Yamashita on 2020/11/04.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

struct Token {
    let surface: String
    let dictionaryDefinitions: [DictionaryDefinition]
    let mecabWordNodes: [MecabWordNode]
    let deinflectionResult: DeinflectionResult?
    let range: NSRange
    let furiganas: [Furigana]
}

class Tokenizer {
    let MAXIMUM_CONCATENATION = 6

    let dictionaryFetcher: DictionaryFetcher = DictionaryFetcher()
    let mecabWrapper: MecabWrapper = MecabWrapper()
    let deinflector: Deinflector = Deinflector()
    
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
                let token = getToken(mecabWordNodes: [firstNode], forceCreateToken: true)
                tokens.append(token!)
                startIndex += 1
                continue
            }
            for concatenationCount in stride(from: MAXIMUM_CONCATENATION, to: 0, by: -1) {
                let endIndex = startIndex + concatenationCount
                if tokenCount < endIndex { continue }
                
                let lastNode = nodes[endIndex - 1]
                if !lastNode.canEndCompoundWord && concatenationCount > 1 { continue }
                
                let nodesToBeConcatenated = Array(nodes[startIndex ..< endIndex])
                let token = getToken(mecabWordNodes: nodesToBeConcatenated, forceCreateToken: concatenationCount == 1)
                if token != nil {
                    tokens.append(token!)
                    startIndex += concatenationCount
                    break
                }
            }
        }
        
        return tokens
    }

    func getToken(mecabWordNodes: [MecabWordNode], forceCreateToken: Bool) -> Token? {
        let concatenatedToken = MecabWordNode.concatenate(mecabWordNodes)
        let text = concatenatedToken.surface
        let deinflectionResults = deinflector.deinflect(text: text)
        for deinflectionResult in deinflectionResults {
            let definitions = searchDictionaryDefinitions(
                nodes: mecabWordNodes,
                deinflectionResult: deinflectionResult
            )
            if !definitions.isEmpty {
                return Token(
                    surface: concatenatedToken.surface,
                    dictionaryDefinitions: definitions,
                    mecabWordNodes: mecabWordNodes,
                    deinflectionResult: deinflectionResult,
                    range: concatenatedToken.range,
                    furiganas: concatenatedToken.furiganas
                )
            }
        }
        return forceCreateToken ? Token(
            surface: concatenatedToken.surface,
            dictionaryDefinitions: [],
            mecabWordNodes: mecabWordNodes,
            deinflectionResult: nil,
            range: concatenatedToken.range,
            furiganas: concatenatedToken.furiganas
        ) : nil
    }
    
    // This function does not filter dictionary definitions by possible parts of speech.
    // Instead, filter plausible definitions when actually displaying them.
    func searchDictionaryDefinitions(nodes: [MecabWordNode], deinflectionResult: DeinflectionResult) -> [DictionaryDefinition] {
        var definitions = [DictionaryDefinition]()
        let entries = dictionaryFetcher.fetchEntries(of: deinflectionResult.text)
        for entry in entries {
            definitions.append(contentsOf: entry.definitions)
        }
        return definitions
    }
}
