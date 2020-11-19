//
//  MecabWrapper.swift
//  Reed
//
//  Created by Shiori Yamashita on 2020/11/02.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

let RESOURCES_BUNDLE_NAME = "mecab-naist-jdic-utf-8"

class MecabWrapper {
    let mecab: Mecab

    init() {
        let bundlePath = Bundle.main.path(forResource: RESOURCES_BUNDLE_NAME, ofType: "bundle")
        let bundleResourcePath = Bundle.init(path: bundlePath!)!.resourcePath
        self.mecab = Mecab.init(dicDirPath: bundleResourcePath!)
    }
    
    func tokenize(_ text: String) -> [MecabWordNode] {
        guard let nodes: [MecabNode] = mecab.parseToNode(with: text) else {
            return [MecabWordNode(
                surface: text,
                featureString: nil,
                partOfSpeech: nil,
                range: (0, text.count)
            )]
        }
        var wordNodes = [MecabWordNode]()
        var index = 0
        for node in nodes {
            let wordLength = node.surface.count
            let leadingWhitespaceLength = Int(node.leadingWhitespaceLength)
            let trailingWhitespaceLength = node.trailingWhitespace?.count ?? 0
            wordNodes.append(MecabWordNode(
                surface: node.surface,
                featureString: node.feature,
                partOfSpeech: convertFeatureStringToPartOfSpeech(node.feature),
                range: (
                    index + leadingWhitespaceLength,
                    index + leadingWhitespaceLength + wordLength)
            ))
            index += leadingWhitespaceLength + wordLength + trailingWhitespaceLength
        }
        return wordNodes
    }
    
    func convertFeatureStringToPartOfSpeech(_ featureString: String?) -> PartOfSpeech? {
        guard let featureString = featureString else { return nil }
        let description = String(featureString.split(separator: ",")[0])
        return PartOfSpeech(rawValue: description)
    }
}
