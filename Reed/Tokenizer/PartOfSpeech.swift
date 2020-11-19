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
    
    var canMakeCompoundWord: Bool {
        switch self {
        case .Symbol:
            return false
        default:
            return true
        }
    }
    
    var canStartCompoundWord: Bool {
        switch self {
        case .Auxiliary, .PostpositionalParticle, .Symbol:
            return false
        default:
            return true
        }
    }
    
    var canEndCompoundWord: Bool {
        switch self {
        case .Adnominal, .PostpositionalParticle, .Prefix, .Symbol:
            return false
        default:
            return true
        }
    }
    
    var isYougen: Bool {
        switch self {
        case .Adjective, .Verb:
            return true
        default:
            return false
        }
    }
}
