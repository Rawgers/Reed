//
//  MecabWordNode.swift
//  Reed
//
//  Created by Shiori Yamashita on 2020/11/04.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

class MecabWordNode {
    let surface: String
    let featureString: String?
    let partOfSpeech: PartOfSpeech?
    let range: (Int, Int) // [start, end)
    
    var canMakeCompoundWord: Bool {
        guard let partOfSpeech = self.partOfSpeech,
              let info = partOfSpeechInfo[partOfSpeech]
        else { return false }
        return info.canMakeCompoundWord
    }
    var canStartCompoundWord: Bool {
        guard let partOfSpeech = self.partOfSpeech,
              let info = partOfSpeechInfo[partOfSpeech]
        else { return false }
        return info.canStartCompoundWord
    }
    var canEndCompoundWord: Bool {
        guard let partOfSpeech = self.partOfSpeech,
              let info = partOfSpeechInfo[partOfSpeech]
        else { return false }
        return info.canEndCompoundWord
    }
    
    init(surface: String, featureString: String?, partOfSpeech: PartOfSpeech?, range: (Int, Int)) {
        self.surface = surface
        self.featureString = featureString
        self.partOfSpeech = partOfSpeech
        self.range = range
    }
    
    static func concatenate(_ nodes: [MecabWordNode]) -> MecabWordNode {
        if nodes.count == 0 {
            return MecabWordNode(
                surface: "",
                featureString: nil,
                partOfSpeech: nil,
                range: (0, 0)
            )
        }
        if nodes.count == 1 {
            return nodes.first!
        }
        let concatenatedSurface = nodes.map { $0.surface } .joined()
        return MecabWordNode(
            surface: concatenatedSurface,
            featureString: nil,
            partOfSpeech: nil,
            range: (nodes.first!.range.0, nodes.last!.range.1)
        )
    }
}
