//
//  MecabWordNode.swift
//  Reed
//
//  Created by Shiori Yamashita on 2020/11/04.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

class MecabWordNode {
    let surface: String
    let features: [String]
    let partOfSpeech: PartOfSpeech?
    let range: (Int, Int) // [start, end)
    let furiganas: [Furigana]
    
    var canMakeCompoundWord: Bool {
        return partOfSpeech?.canMakeCompoundWord ?? false
    }
    var canStartCompoundWord: Bool {
        return partOfSpeech?.canStartCompoundWord ?? false
    }
    var canEndCompoundWord: Bool {
        return partOfSpeech?.canEndCompoundWord ?? false
    }
    var isYougen: Bool {
        return partOfSpeech?.isYougen ?? false
    }
    
    init(surface: String, features: [String], partOfSpeech: PartOfSpeech?, range: (Int, Int), furiganas: [Furigana]) {
        self.surface = surface
        self.features = features
        self.partOfSpeech = partOfSpeech
        self.range = range
        self.furiganas = furiganas
    }
    
    static func concatenate(_ nodes: [MecabWordNode]) -> MecabWordNode {
        if nodes.count == 0 {
            return MecabWordNode(
                surface: "",
                features: [],
                partOfSpeech: nil,
                range: (0, 0),
                furiganas: []
            )
        }
        if nodes.count == 1 {
            return nodes.first!
        }
        let concatenatedSurface = nodes.map { $0.surface } .joined()
        return MecabWordNode(
            surface: concatenatedSurface,
            features: [],
            partOfSpeech: nil,
            range: (nodes.first!.range.0, nodes.last!.range.1),
            furiganas: concatenateFuriganas(of: nodes)
        )
    }
    
    static func concatenateFuriganas(of nodes: [MecabWordNode]) -> [Furigana] {
        var concatenatedFuriganas = [Furigana]()
        var offset = 0
        for node in nodes {
            concatenatedFuriganas.append(
                contentsOf: node.furiganas.map {
                    Furigana(
                        range: ($0.range.0 + offset, $0.range.1 + offset),
                        reading: $0.reading
                    )
                }
            )
            offset += node.range.1 - node.range.0
        }
        return concatenatedFuriganas
    }
    
    static func containsYougen(nodes: [MecabWordNode]) -> Bool {
        return !nodes.allSatisfy({ !$0.isYougen })
    }
}
