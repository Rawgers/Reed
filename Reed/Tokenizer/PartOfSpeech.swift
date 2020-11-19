//
//  WordTypes.swift
//  Reed
//
//  Created by Shiori Yamashita on 2020/11/04.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

enum PartOfSpeech: String {
    case Adjective = "形容詞"
    case Adnominal = "連体詞"
    case Adverb = "副詞"
    case Auxiliary = "助動詞"
    case Conjunction = "接続詞"
    case Filler = "フィラー"
    case Interjection = "感動詞"
    case Noun = "名詞"
    case PostpositionalParticle = "助詞"
    case Prefix = "接頭詞"
    case Symbol = "記号"
    case Verb = "動詞"
}

struct PartOfSpeechInfo {
    let canMakeCompoundWord: Bool
    let canStartCompoundWord: Bool
    let canEndCompoundWord: Bool
}

let partOfSpeechInfo: [PartOfSpeech: PartOfSpeechInfo] = [
    PartOfSpeech.Adjective: PartOfSpeechInfo(
        canMakeCompoundWord: true,
        canStartCompoundWord: true,
        canEndCompoundWord: true
    ),
    PartOfSpeech.Adnominal: PartOfSpeechInfo(
        canMakeCompoundWord: true,
        canStartCompoundWord: true,
        canEndCompoundWord: false
    ),
    PartOfSpeech.Adverb: PartOfSpeechInfo(
        canMakeCompoundWord: true,
        canStartCompoundWord: true,
        canEndCompoundWord: true
    ),
    PartOfSpeech.Auxiliary: PartOfSpeechInfo(
        canMakeCompoundWord: true,
        canStartCompoundWord: false,
        canEndCompoundWord: true
    ),
    PartOfSpeech.Conjunction: PartOfSpeechInfo(
        canMakeCompoundWord: true,
        canStartCompoundWord: true,
        canEndCompoundWord: true
    ),
    PartOfSpeech.Filler: PartOfSpeechInfo(
        canMakeCompoundWord: true,
        canStartCompoundWord: true,
        canEndCompoundWord: true
    ),
    PartOfSpeech.Interjection: PartOfSpeechInfo(
        canMakeCompoundWord: true,
        canStartCompoundWord: true,
        canEndCompoundWord: true
    ),
    PartOfSpeech.Noun: PartOfSpeechInfo(
        canMakeCompoundWord: true,
        canStartCompoundWord: true,
        canEndCompoundWord: true
    ),
    PartOfSpeech.PostpositionalParticle: PartOfSpeechInfo(
        canMakeCompoundWord: true,
        canStartCompoundWord: false,
        canEndCompoundWord: false
    ),
    PartOfSpeech.Prefix: PartOfSpeechInfo(
        canMakeCompoundWord: true,
        canStartCompoundWord: true,
        canEndCompoundWord: false
    ),
    PartOfSpeech.Symbol: PartOfSpeechInfo(
        canMakeCompoundWord: false,
        canStartCompoundWord: false,
        canEndCompoundWord: false
    ),
    PartOfSpeech.Verb: PartOfSpeechInfo(
        canMakeCompoundWord: true,
        canStartCompoundWord: true,
        canEndCompoundWord: true
    )
]
