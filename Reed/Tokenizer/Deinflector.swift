//
//  Deinflector.swift
//  Reed
//
//  Created by Shiori Yamashita on 2020/09/27.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

struct DeinflectionResult {
    let originalText: String
    let text: String
    let conjugationGroupValue: ConjugationGroupValue
    let appliedRules: [Rule]
}

class Deinflector {
    lazy var indexedRules: [Int: [String: [Rule]]] = {
        buildIndexedRules(rules: deinflectionRules)
    }()
    
    // Build a deinflection rule dictionary keyed by the source length and source string
    private func buildIndexedRules(rules: [Rule]) -> [Int: [String: [Rule]]] {
        var indexedRules: [Int: [String: [Rule]]] = [:]
        for rule in rules {
            let sourceLength = rule.source.count
            if indexedRules[sourceLength] == nil {
                indexedRules[sourceLength] = [rule.source: [rule]]
            } else {
                if indexedRules[sourceLength]![rule.source] == nil {
                    indexedRules[sourceLength]![rule.source] = [rule]
                } else {
                    indexedRules[sourceLength]![rule.source]!.append(rule)
                }
            }
        }
        return indexedRules
    }
    
    // Returns an empty list if the text cannot be further deinflected
    func deinflect(text: String) -> [DeinflectionResult] {
        return recursivelyDeinflect(result: DeinflectionResult(
            originalText: text,
            text: text,
            conjugationGroupValue: ConjugationGroup.Anything,
            appliedRules: []
        ))
    }
    
    // TODO: Set the maximum number of recursive deinflections to avoid infinite loop
    func recursivelyDeinflect(result: DeinflectionResult) -> [DeinflectionResult] {
        let text = result.text
        var allResults = [result]
        for sourceLength in indexedRules.keys {
            if text.count < sourceLength { continue }
            
            let suffix = String(text.suffix(sourceLength))
            guard let rules = indexedRules[sourceLength]![suffix] else {
                continue
            }
            
            // Filter applicable rules by possible conjugation groups
            let applicableRules = rules.filter {
                $0.sourceConjugationGroupValue & result.conjugationGroupValue > 0
            }
            let results = applyRules(result: result, applicableRules: applicableRules)
            
            // Try to deinflect further
            for result in results {
                allResults.append(contentsOf: recursivelyDeinflect(result: result))
            }
        }
        return allResults
    }
    
    func applyRules(result: DeinflectionResult, applicableRules: [Rule]) -> [DeinflectionResult] {
        let text = result.text
        return applicableRules.map {
            DeinflectionResult(
                originalText: text,
                text: String(text.prefix(text.count - $0.source.count)) + $0.target,
                conjugationGroupValue: $0.targetConjugationGroupValue,
                appliedRules: result.appliedRules + [$0]
            )
        }
    }
}
