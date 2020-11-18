//
//  PartOfSpeechMatcher.swift
//  Reed
//
//  Created by Shiori Yamashita on 2020/11/08.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

enum PartOfSpeechMatchLevel {
    case Primary
    case Secondary
    case None
}

struct PartOfSpeechConversionDestination {
    let primary: [String]
    let secondary: [String]
}

// "記号" is not converted
let partOfSpeechConversion: [String: Any] = [
    "その他": PartOfSpeechConversionDestination(
        primary: ["prt", "cop", "exp", "int", "unc"],
        secondary: []
    ),
    "フィラー": PartOfSpeechConversionDestination(
        primary: ["conj", "exp", "int"],
        secondary: []
    ),
    "感動詞": PartOfSpeechConversionDestination(
        primary: ["conj", "exp", "int"],
        secondary: []
    ),
    "形容詞": PartOfSpeechConversionDestination(
        primary: ["adj-f", "adj-i", "adj-ix", "adj-kari", "adj-ku", "adj-shiku"],
        secondary: ["adj-na", "adj-nari", "adj-no", "adj-pn", "adj-t", "aux-adj"]
    ),
    // TODO: 格助詞の連語やばい
    "助詞": PartOfSpeechConversionDestination(
        primary: ["prt"],
        secondary: ["aux", "aux-adj", "aux-v", "conj", "cop"]
    ),
    "助動詞": PartOfSpeechConversionDestination(
        primary: ["aux", "aux-adj", "aux-v", "cop"],
        secondary: ["v-unspec"]
    ),
    "接続詞": PartOfSpeechConversionDestination(
        primary: ["conj"],
        secondary: ["int", "exp"]
    ),
    "接頭詞": PartOfSpeechConversionDestination(
        primary: ["pref", "n-pref"],
        secondary: ["adj-f", "adj-pn"]
    ),
    "動詞": PartOfSpeechConversionDestination(
        primary: [
            "v-unspec",
            "v1", "v1-s",
            "v2a-s", "v2b-k", "v2b-s", "v2d-k", "v2d-s", "v2g-k", "v2g-s", "v2h-k", "v2h-s", "v2k-k", "v2k-s", "v2m-k", "v2m-s", "v2n-s", "v2r-k", "v2r-s", "v2s-s", "v2t-k", "v2t-s", "v2w-s", "v2y-k", "v2y-s", "v2z-s",
            "v4b", "v4g", "v4h", "v4k", "v4m", "v4n", "v4r", "v4s", "v4t",
            "v5aru", "v5b", "v5g", "v5k", "v5k-s", "v5m", "v5n", "v5r", "v5r-i", "v5s", "v5t", "v5u", "v5u-s", "v5uru",
            "vi", "vk", "vn", "vr", "vs", "vs-c", "vs-i", "vs-s", "vt", "vz"
        ],
        secondary: ["adj-f", "exp"]
    ),
    "副詞": PartOfSpeechConversionDestination(
        primary: ["adv", "adv-to"],
        secondary: ["n-t"]
    ),
    "名詞": [
        "サ変接続": PartOfSpeechConversionDestination(
            primary: ["vs", "n"],
            secondary: []
        ),
        // Becomes "adj-i" when followed by "ない"
        "ナイ形容詞語幹": PartOfSpeechConversionDestination(
            primary: ["vs"],
            secondary: ["adj-i", "adj-ku"]
        ),
        "一般": PartOfSpeechConversionDestination(
            primary: ["n", "n-adv", "adj-f", "adj-na", "adj-nari", "adj-no", "adj-t", "adv-to"],
            secondary: ["suf", "n-suf", "adv", "ctr", "exp", "int", "unc", "vs"]
        ),
        "引用文字列": PartOfSpeechConversionDestination(
            primary: ["n"],
            secondary: []
        ),
        "形容動詞語幹": PartOfSpeechConversionDestination(
            primary: ["adj-na", "adj-nari", "adj-no"],
            secondary: ["adj-t", "adj-to", "n"]
        ),
        "固有名詞": PartOfSpeechConversionDestination(
            primary: ["n"],
            secondary: []
        ),
        "数": PartOfSpeechConversionDestination(
            primary: ["num"],
            secondary: ["n", "ctr", "pref"]
        ),
        "接続詞的": PartOfSpeechConversionDestination(
            primary: ["n", "conj"],
            secondary: []
        ),
        "接尾": PartOfSpeechConversionDestination(
            primary: ["suf", "n", "n-suf"],
            secondary: ["prt"]
        ),
        "代名詞": PartOfSpeechConversionDestination(
            primary: ["pn"],
            secondary: ["n-adv", "n", "n-t"]
        ),
        "動詞非自立的": PartOfSpeechConversionDestination(
            primary: ["n", "vs", "int", "exp"],
            secondary: []
        ),
        // Assuming its only subgroup is "助動詞語幹"
        "特殊": PartOfSpeechConversionDestination(
            primary: ["aux", "adj-na"],
            secondary: []
        ),
        "非自立": PartOfSpeechConversionDestination(
            primary: ["n", "n-suf", "suf", "adj-na", "aux"],
            secondary: []
        ),
        "副詞可能": PartOfSpeechConversionDestination(
            primary: ["n-t", "n-adv"],
            secondary: ["n"]
        ),
    ],
    "連体詞": PartOfSpeechConversionDestination(
        primary: ["adj-f", "adj-pn"],
        secondary: []
    ),
    "*": PartOfSpeechConversionDestination(
        primary: ["unc"],
        secondary: []
    ),
]

// TODO: Needs some caching
class PartOfSpeechMatcher {
    
    func match(features: [String], jmdictPartsOfSpeech: [String]) -> PartOfSpeechMatchLevel {
        if features.isEmpty || jmdictPartsOfSpeech.isEmpty {
            return PartOfSpeechMatchLevel.None
        }
        
        let conversionDestination = convert(features: features)
        let isPrimary = jmdictPartsOfSpeech.contains { conversionDestination.primary.contains($0) }
        if isPrimary {
            return PartOfSpeechMatchLevel.Primary
        }
        let isSecondary = jmdictPartsOfSpeech.contains { conversionDestination.secondary.contains($0) }
        if isSecondary {
            return PartOfSpeechMatchLevel.Secondary
        }
        return PartOfSpeechMatchLevel.None
    }
    
    func convert(features: [String]) -> PartOfSpeechConversionDestination {
        let destination = recursivelyConvert(
            features: features,
            conversionMap: partOfSpeechConversion
        )
        // TODO: Do this somewhere else
        return PartOfSpeechConversionDestination(
            primary: destination.primary.map { "&" + $0 + ";" },
            secondary: destination.secondary.map { "&" + $0 + ";" }
        )
    }

    func recursivelyConvert(features: [String], conversionMap: [String: Any]) -> PartOfSpeechConversionDestination {
        let firstFeature = features.first!
        let isKey = conversionMap.keys.contains(firstFeature)
        let value = conversionMap[isKey ? firstFeature : "*"]
        if value is PartOfSpeechConversionDestination {
            return value as! PartOfSpeechConversionDestination
        } else {
            return recursivelyConvert(
                features: Array(features[1 ..< features.endIndex]),
                conversionMap: value as! [String: Any]
            )
        }
    }
    
}
