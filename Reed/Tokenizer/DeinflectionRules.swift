//
//  DeinflectionRules.swift
//  Reed
//
//  Created by Shiori Yamashita on 2020/10/11.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

// These rules are taken from https://github.com/birtles/rikaichamp

// A value of ConjugationGroup or a combination of multiple ConjugationGroup's
typealias ConjugationGroupValue = UInt8

struct Rule {
    let source: String
    let target: String
    let sourceConjugationGroupValue: ConjugationGroupValue
    let targetConjugationGroupValue: ConjugationGroupValue
    let reason: DeinflectionReason
}

enum DeinflectionReason {
    case Adv
    case Ba
    case Causative
    case CausativePassive
    case Chau
    case Continuous
    case Imperative
    case ImperativeNegative
    case MasuStem
    case Nasai
    case Negative
    case Noun
    case Passive
    case Past
    case Polite
    case PoliteNegative
    case PolitePast
    case PolitePastNegative
    case PoliteVolitional
    case Potential
    case PotentialOrPassive
    case Sou
    case Sugiru
    case Tai
    case Tara
    case Tari
    case Te
    case Toku
    case Volitional
    case Zu
}

enum ConjugationGroup {
    static let IchidanVerb: ConjugationGroupValue = 0b00000001
    static let GodanVerb: ConjugationGroupValue = 0b00000010
    static let IAdjective: ConjugationGroupValue = 0b00000100
    static let KuruVerb: ConjugationGroupValue = 0b00001000
    static let SuruVerb: ConjugationGroupValue = 0b00010000
    
    // Does not match the result of any deinflection, but matches the Anything type
    static let NotResultOfAnyDeinflection: ConjugationGroupValue = 0b10000000
    
    // The initial state where the conjugation group of the word is unknown
    static let Anything: ConjugationGroupValue = 0b11111111
}

let deinflectionRules = [
    Rule(
        source: "いらっしゃいませんでした",
        target: "いらっしゃる",
        sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
        targetConjugationGroupValue: ConjugationGroup.GodanVerb,
        reason: DeinflectionReason.PolitePastNegative
    ),
    Rule(
      source: "おっしゃいませんでした",
      target: "おっしゃる",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.PolitePastNegative
    ),
    Rule(
      source: "いらっしゃいました",
      target: "いらっしゃる",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.PolitePast
    ),
    Rule(
      source: "くありませんでした",
      target: "い",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.IAdjective,
      reason: DeinflectionReason.PolitePastNegative
    ),
    Rule(
      source: "いらっしゃいます",
      target: "いらっしゃる",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Polite
    ),
    Rule(
      source: "おっしゃいました",
      target: "おっしゃる",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.PolitePast
    ),
    Rule(
      source: "仰いませんでした",
      target: "仰る",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.PolitePastNegative
    ),
    Rule(
      source: "いませんでした",
      target: "う",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.PolitePastNegative
    ),
    Rule(
      source: "おっしゃいます",
      target: "おっしゃる",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Polite
    ),
    Rule(
      source: "きませんでした",
      target: "く",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.PolitePastNegative
    ),
    Rule(
      source: "きませんでした",
      target: "くる",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.KuruVerb,
      reason: DeinflectionReason.PolitePastNegative
    ),
    Rule(
      source: "ぎませんでした",
      target: "ぐ",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.PolitePastNegative
    ),
    Rule(
      source: "しませんでした",
      target: "す",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.PolitePastNegative
    ),
    Rule(
      source: "しませんでした",
      target: "する",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.SuruVerb,
      reason: DeinflectionReason.PolitePastNegative
    ),
    Rule(
      source: "ちませんでした",
      target: "つ",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.PolitePastNegative
    ),
    Rule(
      source: "にませんでした",
      target: "ぬ",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.PolitePastNegative
    ),
    Rule(
      source: "びませんでした",
      target: "ぶ",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.PolitePastNegative
    ),
    Rule(
      source: "みませんでした",
      target: "む",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.PolitePastNegative
    ),
    Rule(
      source: "りませんでした",
      target: "る",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.PolitePastNegative
    ),
    Rule(
      source: "いらっしゃい",
      target: "いらっしゃる",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.MasuStem
    ),
    Rule(
      source: "いらっしゃい",
      target: "いらっしゃる",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Imperative
    ),
    Rule(
      source: "くありません",
      target: "い",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.IAdjective,
      reason: DeinflectionReason.PoliteNegative
    ),
    Rule(
      source: "ませんでした",
      target: "る",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.IchidanVerb | ConjugationGroup.KuruVerb,
      reason: DeinflectionReason.PolitePastNegative
    ),
    Rule(
      source: "のたもうたら",
      target: "のたまう",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Tara
    ),
    Rule(
      source: "のたもうたり",
      target: "のたまう",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Tari
    ),
    Rule(
      source: "いましょう",
      target: "う",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.PoliteVolitional
    ),
    Rule(
      source: "仰いました",
      target: "仰る",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.PolitePast
    ),
    Rule(
      source: "おっしゃい",
      target: "おっしゃる",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.MasuStem
    ),
    Rule(
      source: "おっしゃい",
      target: "おっしゃる",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Imperative
    ),
    Rule(
      source: "きましょう",
      target: "く",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.PoliteVolitional
    ),
    Rule(
      source: "きましょう",
      target: "くる",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.KuruVerb,
      reason: DeinflectionReason.PoliteVolitional
    ),
    Rule(
      source: "ぎましょう",
      target: "ぐ",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.PoliteVolitional
    ),
    Rule(
      source: "しましょう",
      target: "す",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.PoliteVolitional
    ),
    Rule(
      source: "しましょう",
      target: "する",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.SuruVerb,
      reason: DeinflectionReason.PoliteVolitional
    ),
    Rule(
      source: "ちましょう",
      target: "つ",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.PoliteVolitional
    ),
    Rule(
      source: "にましょう",
      target: "ぬ",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.PoliteVolitional
    ),
    Rule(
      source: "のたもうた",
      target: "のたまう",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Past
    ),
    Rule(
      source: "のたもうて",
      target: "のたまう",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Te
    ),
    Rule(
      source: "びましょう",
      target: "ぶ",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.PoliteVolitional
    ),
    Rule(
      source: "みましょう",
      target: "む",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.PoliteVolitional
    ),
    Rule(
      source: "りましょう",
      target: "る",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.PoliteVolitional
    ),
    Rule(
      source: "いじゃう",
      target: "ぐ",
      sourceConjugationGroupValue: ConjugationGroup.GodanVerb,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Chau
    ),
    Rule(
      source: "いすぎる",
      target: "う",
      sourceConjugationGroupValue: ConjugationGroup.IchidanVerb,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Sugiru
    ),
    Rule(
      source: "いちゃう",
      target: "く",
      sourceConjugationGroupValue: ConjugationGroup.GodanVerb,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Chau
    ),
    Rule(
      source: "いったら",
      target: "いく",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Tara
    ),
    Rule(
      source: "いったり",
      target: "いく",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Tari
    ),
    Rule(
      source: "いている",
      target: "く",
      sourceConjugationGroupValue: ConjugationGroup.IchidanVerb,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Continuous
    ),
    Rule(
      source: "いでいる",
      target: "ぐ",
      sourceConjugationGroupValue: ConjugationGroup.IchidanVerb,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Continuous
    ),
    Rule(
      source: "いなさい",
      target: "う",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Nasai
    ),
    Rule(
      source: "いました",
      target: "う",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.PolitePast
    ),
    Rule(
      source: "いません",
      target: "う",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.PoliteNegative
    ),
    Rule(
      source: "おうたら",
      target: "おう",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Tara
    ),
    Rule(
      source: "おうたり",
      target: "おう",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Tari
    ),
    Rule(
      source: "仰います",
      target: "仰る",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Polite
    ),
    Rule(
      source: "かされる",
      target: "く",
      sourceConjugationGroupValue: ConjugationGroup.IchidanVerb,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.CausativePassive
    ),
    Rule(
      source: "かったら",
      target: "い",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.IAdjective,
      reason: DeinflectionReason.Tara
    ),
    Rule(
      source: "かったり",
      target: "い",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.IAdjective,
      reason: DeinflectionReason.Tari
    ),
    Rule(
      source: "がされる",
      target: "ぐ",
      sourceConjugationGroupValue: ConjugationGroup.IchidanVerb,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.CausativePassive
    ),
    Rule(
      source: "きすぎる",
      target: "く",
      sourceConjugationGroupValue: ConjugationGroup.IchidanVerb,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Sugiru
    ),
    Rule(
      source: "きすぎる",
      target: "くる",
      sourceConjugationGroupValue: ConjugationGroup.IchidanVerb,
      targetConjugationGroupValue: ConjugationGroup.KuruVerb,
      reason: DeinflectionReason.Sugiru
    ),
    Rule(
      source: "ぎすぎる",
      target: "ぐ",
      sourceConjugationGroupValue: ConjugationGroup.IchidanVerb,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Sugiru
    ),
    Rule(
      source: "きちゃう",
      target: "くる",
      sourceConjugationGroupValue: ConjugationGroup.GodanVerb,
      targetConjugationGroupValue: ConjugationGroup.KuruVerb,
      reason: DeinflectionReason.Chau
    ),
    Rule(
      source: "きている",
      target: "くる",
      sourceConjugationGroupValue: ConjugationGroup.IchidanVerb,
      targetConjugationGroupValue: ConjugationGroup.KuruVerb,
      reason: DeinflectionReason.Continuous
    ),
    Rule(
      source: "きなさい",
      target: "く",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Nasai
    ),
    Rule(
      source: "きなさい",
      target: "くる",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.KuruVerb,
      reason: DeinflectionReason.Nasai
    ),
    Rule(
      source: "ぎなさい",
      target: "ぐ",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Nasai
    ),
    Rule(
      source: "きました",
      target: "く",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.PolitePast
    ),
    Rule(
      source: "きました",
      target: "くる",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.KuruVerb,
      reason: DeinflectionReason.PolitePast
    ),
    Rule(
      source: "ぎました",
      target: "ぐ",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.PolitePast
    ),
    Rule(
      source: "きません",
      target: "く",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.PoliteNegative
    ),
    Rule(
      source: "きません",
      target: "くる",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.KuruVerb,
      reason: DeinflectionReason.PoliteNegative
    ),
    Rule(
      source: "ぎません",
      target: "ぐ",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.PoliteNegative
    ),
    Rule(
      source: "こうたら",
      target: "こう",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Tara
    ),
    Rule(
      source: "こうたり",
      target: "こう",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Tari
    ),
    Rule(
      source: "こさせる",
      target: "くる",
      sourceConjugationGroupValue: ConjugationGroup.IchidanVerb,
      targetConjugationGroupValue: ConjugationGroup.KuruVerb,
      reason: DeinflectionReason.Causative
    ),
    Rule(
      source: "こられる",
      target: "くる",
      sourceConjugationGroupValue: ConjugationGroup.IchidanVerb,
      targetConjugationGroupValue: ConjugationGroup.KuruVerb,
      reason: DeinflectionReason.PotentialOrPassive
    ),
    Rule(
      source: "しすぎる",
      target: "す",
      sourceConjugationGroupValue: ConjugationGroup.IchidanVerb,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Sugiru
    ),
    Rule(
      source: "しすぎる",
      target: "する",
      sourceConjugationGroupValue: ConjugationGroup.IchidanVerb,
      targetConjugationGroupValue: ConjugationGroup.SuruVerb,
      reason: DeinflectionReason.Sugiru
    ),
    Rule(
      source: "しちゃう",
      target: "す",
      sourceConjugationGroupValue: ConjugationGroup.GodanVerb,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Chau
    ),
    Rule(
      source: "しちゃう",
      target: "する",
      sourceConjugationGroupValue: ConjugationGroup.GodanVerb,
      targetConjugationGroupValue: ConjugationGroup.SuruVerb,
      reason: DeinflectionReason.Chau
    ),
    Rule(
      source: "している",
      target: "す",
      sourceConjugationGroupValue: ConjugationGroup.IchidanVerb,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Continuous
    ),
    Rule(
      source: "している",
      target: "する",
      sourceConjugationGroupValue: ConjugationGroup.IchidanVerb,
      targetConjugationGroupValue: ConjugationGroup.SuruVerb,
      reason: DeinflectionReason.Continuous
    ),
    Rule(
      source: "しなさい",
      target: "す",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Nasai
    ),
    Rule(
      source: "しなさい",
      target: "する",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.SuruVerb,
      reason: DeinflectionReason.Nasai
    ),
    Rule(
      source: "しました",
      target: "す",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.PolitePast
    ),
    Rule(
      source: "しました",
      target: "する",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.SuruVerb,
      reason: DeinflectionReason.PolitePast
    ),
    Rule(
      source: "しません",
      target: "す",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.PoliteNegative
    ),
    Rule(
      source: "しません",
      target: "する",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.SuruVerb,
      reason: DeinflectionReason.PoliteNegative
    ),
    Rule(
      source: "そうたら",
      target: "そう",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Tara
    ),
    Rule(
      source: "そうたり",
      target: "そう",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Tari
    ),
    Rule(
      source: "たされる",
      target: "つ",
      sourceConjugationGroupValue: ConjugationGroup.IchidanVerb,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.CausativePassive
    ),
    Rule(
      source: "ちすぎる",
      target: "つ",
      sourceConjugationGroupValue: ConjugationGroup.IchidanVerb,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Sugiru
    ),
    Rule(
      source: "ちなさい",
      target: "つ",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Nasai
    ),
    Rule(
      source: "ちました",
      target: "つ",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.PolitePast
    ),
    Rule(
      source: "ちません",
      target: "つ",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.PoliteNegative
    ),
    Rule(
      source: "っちゃう",
      target: "う",
      sourceConjugationGroupValue: ConjugationGroup.GodanVerb,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Chau
    ),
    Rule(
      source: "っちゃう",
      target: "く",
      sourceConjugationGroupValue: ConjugationGroup.GodanVerb,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Chau
    ),
    Rule(
      source: "っちゃう",
      target: "つ",
      sourceConjugationGroupValue: ConjugationGroup.GodanVerb,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Chau
    ),
    Rule(
      source: "っちゃう",
      target: "る",
      sourceConjugationGroupValue: ConjugationGroup.GodanVerb,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Chau
    ),
    Rule(
      source: "っている",
      target: "う",
      sourceConjugationGroupValue: ConjugationGroup.IchidanVerb,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Continuous
    ),
    Rule(
      source: "っている",
      target: "つ",
      sourceConjugationGroupValue: ConjugationGroup.IchidanVerb,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Continuous
    ),
    Rule(
      source: "っている",
      target: "る",
      sourceConjugationGroupValue: ConjugationGroup.IchidanVerb,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Continuous
    ),
    Rule(
      source: "とうたら",
      target: "とう",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Tara
    ),
    Rule(
      source: "とうたり",
      target: "とう",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Tari
    ),
    Rule(
      source: "なされる",
      target: "ぬ",
      sourceConjugationGroupValue: ConjugationGroup.IchidanVerb,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.CausativePassive
    ),
    Rule(
      source: "にすぎる",
      target: "ぬ",
      sourceConjugationGroupValue: ConjugationGroup.IchidanVerb,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Sugiru
    ),
    Rule(
      source: "になさい",
      target: "ぬ",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Nasai
    ),
    Rule(
      source: "にました",
      target: "ぬ",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.PolitePast
    ),
    Rule(
      source: "にません",
      target: "ぬ",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.PoliteNegative
    ),
    Rule(
      source: "ばされる",
      target: "ぶ",
      sourceConjugationGroupValue: ConjugationGroup.IchidanVerb,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.CausativePassive
    ),
    Rule(
      source: "びすぎる",
      target: "ぶ",
      sourceConjugationGroupValue: ConjugationGroup.IchidanVerb,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Sugiru
    ),
    Rule(
      source: "びなさい",
      target: "ぶ",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Nasai
    ),
    Rule(
      source: "びました",
      target: "ぶ",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.PolitePast
    ),
    Rule(
      source: "びません",
      target: "ぶ",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.PoliteNegative
    ),
    Rule(
      source: "まされる",
      target: "む",
      sourceConjugationGroupValue: ConjugationGroup.IchidanVerb,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.CausativePassive
    ),
    Rule(
      source: "ましょう",
      target: "る",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.IchidanVerb | ConjugationGroup.KuruVerb,
      reason: DeinflectionReason.PoliteVolitional
    ),
    Rule(
      source: "みすぎる",
      target: "む",
      sourceConjugationGroupValue: ConjugationGroup.IchidanVerb,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Sugiru
    ),
    Rule(
      source: "みなさい",
      target: "む",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Nasai
    ),
    Rule(
      source: "みました",
      target: "む",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.PolitePast
    ),
    Rule(
      source: "みません",
      target: "む",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.PoliteNegative
    ),
    Rule(
      source: "らされる",
      target: "る",
      sourceConjugationGroupValue: ConjugationGroup.IchidanVerb,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.CausativePassive
    ),
    Rule(
      source: "りすぎる",
      target: "る",
      sourceConjugationGroupValue: ConjugationGroup.IchidanVerb,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Sugiru
    ),
    Rule(
      source: "りなさい",
      target: "る",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Nasai
    ),
    Rule(
      source: "りました",
      target: "る",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.PolitePast
    ),
    Rule(
      source: "りません",
      target: "る",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.PoliteNegative
    ),
    Rule(
      source: "わされる",
      target: "う",
      sourceConjugationGroupValue: ConjugationGroup.IchidanVerb,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.CausativePassive
    ),
    Rule(
      source: "んじゃう",
      target: "ぬ",
      sourceConjugationGroupValue: ConjugationGroup.GodanVerb,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Chau
    ),
    Rule(
      source: "んじゃう",
      target: "ぶ",
      sourceConjugationGroupValue: ConjugationGroup.GodanVerb,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Chau
    ),
    Rule(
      source: "んじゃう",
      target: "む",
      sourceConjugationGroupValue: ConjugationGroup.GodanVerb,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Chau
    ),
    Rule(
      source: "んでいる",
      target: "ぬ",
      sourceConjugationGroupValue: ConjugationGroup.IchidanVerb,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Continuous
    ),
    Rule(
      source: "んでいる",
      target: "ぶ",
      sourceConjugationGroupValue: ConjugationGroup.IchidanVerb,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Continuous
    ),
    Rule(
      source: "んでいる",
      target: "む",
      sourceConjugationGroupValue: ConjugationGroup.IchidanVerb,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Continuous
    ),
    Rule(
      source: "行ったら",
      target: "行く",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Tara
    ),
    Rule(
      source: "行ったり",
      target: "行く",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Tari
    ),
    Rule(
      source: "逝ったら",
      target: "逝く",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Tara
    ),
    Rule(
      source: "逝ったり",
      target: "逝く",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Tari
    ),
    Rule(
      source: "往ったら",
      target: "往く",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Tara
    ),
    Rule(
      source: "往ったり",
      target: "往く",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Tari
    ),
    Rule(
      source: "逝ったら",
      target: "逝く",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Tara
    ),
    Rule(
      source: "逝ったり",
      target: "逝く",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Tari
    ),
    Rule(
      source: "往ったら",
      target: "往く",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Tara
    ),
    Rule(
      source: "往ったり",
      target: "往く",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Tari
    ),
    Rule(
      source: "請うたら",
      target: "請う",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Tara
    ),
    Rule(
      source: "請うたり",
      target: "請う",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Tari
    ),
    Rule(
      source: "乞うたら",
      target: "乞う",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Tara
    ),
    Rule(
      source: "乞うたり",
      target: "乞う",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Tari
    ),
    Rule(
      source: "恋うたら",
      target: "恋う",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Tara
    ),
    Rule(
      source: "恋うたり",
      target: "恋う",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Tari
    ),
    Rule(
      source: "来させる",
      target: "来る",
      sourceConjugationGroupValue: ConjugationGroup.IchidanVerb,
      targetConjugationGroupValue: ConjugationGroup.KuruVerb,
      reason: DeinflectionReason.Causative
    ),
    Rule(
      source: "來させる",
      target: "來る",
      sourceConjugationGroupValue: ConjugationGroup.IchidanVerb,
      targetConjugationGroupValue: ConjugationGroup.KuruVerb,
      reason: DeinflectionReason.Causative
    ),
    Rule(
      source: "来ました",
      target: "来る",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.KuruVerb,
      reason: DeinflectionReason.PolitePast
    ),
    Rule(
      source: "来ません",
      target: "来る",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.KuruVerb,
      reason: DeinflectionReason.PoliteNegative
    ),
    Rule(
      source: "來ました",
      target: "來る",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.KuruVerb,
      reason: DeinflectionReason.PolitePast
    ),
    Rule(
      source: "來ません",
      target: "來る",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.KuruVerb,
      reason: DeinflectionReason.PoliteNegative
    ),
    Rule(
      source: "来られる",
      target: "来る",
      sourceConjugationGroupValue: ConjugationGroup.IchidanVerb,
      targetConjugationGroupValue: ConjugationGroup.KuruVerb,
      reason: DeinflectionReason.PotentialOrPassive
    ),
    Rule(
      source: "來られる",
      target: "來る",
      sourceConjugationGroupValue: ConjugationGroup.IchidanVerb,
      targetConjugationGroupValue: ConjugationGroup.KuruVerb,
      reason: DeinflectionReason.PotentialOrPassive
    ),
    Rule(
      source: "問うたら",
      target: "問う",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Tara
    ),
    Rule(
      source: "問うたり",
      target: "問う",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Tari
    ),
    Rule(
      source: "負うたら",
      target: "負う",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Tara
    ),
    Rule(
      source: "負うたり",
      target: "負う",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Tari
    ),
    Rule(
      source: "沿うたら",
      target: "沿う",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Tara
    ),
    Rule(
      source: "沿うたり",
      target: "沿う",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Tari
    ),
    Rule(
      source: "添うたら",
      target: "添う",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Tara
    ),
    Rule(
      source: "添うたり",
      target: "添う",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Tari
    ),
    Rule(
      source: "副うたら",
      target: "副う",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Tara
    ),
    Rule(
      source: "副うたり",
      target: "副う",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Tari
    ),
    Rule(
      source: "厭うたら",
      target: "厭う",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Tara
    ),
    Rule(
      source: "厭うたり",
      target: "厭う",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Tari
    ),
    Rule(
      source: "いそう",
      target: "う",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Sou
    ),
    Rule(
      source: "いたい",
      target: "う",
      sourceConjugationGroupValue: ConjugationGroup.IAdjective,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Tai
    ),
    Rule(
      source: "いたら",
      target: "く",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Tara
    ),
    Rule(
      source: "いだら",
      target: "ぐ",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Tara
    ),
    Rule(
      source: "いたり",
      target: "く",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Tari
    ),
    Rule(
      source: "いだり",
      target: "ぐ",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Tari
    ),
    Rule(
      source: "いった",
      target: "いく",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Past
    ),
    Rule(
      source: "いって",
      target: "いく",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Te
    ),
    Rule(
      source: "いてる",
      target: "く",
      sourceConjugationGroupValue: ConjugationGroup.IchidanVerb,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Continuous
    ),
    Rule(
      source: "いでる",
      target: "ぐ",
      sourceConjugationGroupValue: ConjugationGroup.IchidanVerb,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Continuous
    ),
    Rule(
      source: "いとく",
      target: "く",
      sourceConjugationGroupValue: ConjugationGroup.GodanVerb,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Toku
    ),
    Rule(
      source: "いどく",
      target: "ぐ",
      sourceConjugationGroupValue: ConjugationGroup.GodanVerb,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Toku
    ),
    Rule(
      source: "います",
      target: "う",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Polite
    ),
    Rule(
      source: "おうた",
      target: "おう",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Past
    ),
    Rule(
      source: "おうて",
      target: "おう",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Te
    ),
    Rule(
      source: "かせる",
      target: "く",
      sourceConjugationGroupValue: ConjugationGroup.IchidanVerb,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Causative
    ),
    Rule(
      source: "がせる",
      target: "ぐ",
      sourceConjugationGroupValue: ConjugationGroup.IchidanVerb,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Causative
    ),
    Rule(
      source: "かった",
      target: "い",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.IAdjective,
      reason: DeinflectionReason.Past
    ),
    Rule(
      source: "かない",
      target: "く",
      sourceConjugationGroupValue: ConjugationGroup.IAdjective,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Negative
    ),
    Rule(
      source: "がない",
      target: "ぐ",
      sourceConjugationGroupValue: ConjugationGroup.IAdjective,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Negative
    ),
    Rule(
      source: "かれる",
      target: "く",
      sourceConjugationGroupValue: ConjugationGroup.IchidanVerb,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Passive
    ),
    Rule(
      source: "がれる",
      target: "ぐ",
      sourceConjugationGroupValue: ConjugationGroup.IchidanVerb,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Passive
    ),
    Rule(
      source: "きそう",
      target: "く",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Sou
    ),
    Rule(
      source: "きそう",
      target: "くる",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.KuruVerb,
      reason: DeinflectionReason.Sou
    ),
    Rule(
      source: "ぎそう",
      target: "ぐ",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Sou
    ),
    Rule(
      source: "きたい",
      target: "く",
      sourceConjugationGroupValue: ConjugationGroup.IAdjective,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Tai
    ),
    Rule(
      source: "きたい",
      target: "くる",
      sourceConjugationGroupValue: ConjugationGroup.IAdjective,
      targetConjugationGroupValue: ConjugationGroup.KuruVerb,
      reason: DeinflectionReason.Tai
    ),
    Rule(
      source: "ぎたい",
      target: "ぐ",
      sourceConjugationGroupValue: ConjugationGroup.IAdjective,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Tai
    ),
    Rule(
      source: "きたら",
      target: "くる",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.KuruVerb,
      reason: DeinflectionReason.Tara
    ),
    Rule(
      source: "きたり",
      target: "くる",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.KuruVerb,
      reason: DeinflectionReason.Tari
    ),
    Rule(
      source: "きてる",
      target: "くる",
      sourceConjugationGroupValue: ConjugationGroup.IchidanVerb,
      targetConjugationGroupValue: ConjugationGroup.KuruVerb,
      reason: DeinflectionReason.Continuous
    ),
    Rule(
      source: "きとく",
      target: "くる",
      sourceConjugationGroupValue: ConjugationGroup.GodanVerb,
      targetConjugationGroupValue: ConjugationGroup.KuruVerb,
      reason: DeinflectionReason.Toku
    ),
    Rule(
      source: "きます",
      target: "く",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Polite
    ),
    Rule(
      source: "きます",
      target: "くる",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.KuruVerb,
      reason: DeinflectionReason.Polite
    ),
    Rule(
      source: "ぎます",
      target: "ぐ",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Polite
    ),
    Rule(
      source: "くない",
      target: "い",
      sourceConjugationGroupValue: ConjugationGroup.IAdjective,
      targetConjugationGroupValue: ConjugationGroup.IAdjective,
      reason: DeinflectionReason.Negative
    ),
    Rule(
      source: "ければ",
      target: "い",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.IAdjective,
      reason: DeinflectionReason.Ba
    ),
    Rule(
      source: "こうた",
      target: "こう",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Past
    ),
    Rule(
      source: "こうて",
      target: "こう",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Te
    ),
    Rule(
      source: "こない",
      target: "くる",
      sourceConjugationGroupValue: ConjugationGroup.IAdjective,
      targetConjugationGroupValue: ConjugationGroup.KuruVerb,
      reason: DeinflectionReason.Negative
    ),
    Rule(
      source: "こよう",
      target: "くる",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.KuruVerb,
      reason: DeinflectionReason.Volitional
    ),
    Rule(
      source: "これる",
      target: "くる",
      sourceConjugationGroupValue: ConjugationGroup.IchidanVerb,
      targetConjugationGroupValue: ConjugationGroup.KuruVerb,
      reason: DeinflectionReason.Potential
    ),
    Rule(
      source: "来れる",
      target: "来る",
      sourceConjugationGroupValue: ConjugationGroup.IchidanVerb,
      targetConjugationGroupValue: ConjugationGroup.KuruVerb,
      reason: DeinflectionReason.Potential
    ),
    Rule(
      source: "來れる",
      target: "來る",
      sourceConjugationGroupValue: ConjugationGroup.IchidanVerb,
      targetConjugationGroupValue: ConjugationGroup.KuruVerb,
      reason: DeinflectionReason.Potential
    ),
    Rule(
      source: "させる",
      target: "する",
      sourceConjugationGroupValue: ConjugationGroup.IchidanVerb,
      targetConjugationGroupValue: ConjugationGroup.SuruVerb,
      reason: DeinflectionReason.Causative
    ),
    Rule(
      source: "させる",
      target: "る",
      sourceConjugationGroupValue: ConjugationGroup.IchidanVerb,
      targetConjugationGroupValue: ConjugationGroup.IchidanVerb,
      reason: DeinflectionReason.Causative
    ),
    Rule(
      source: "させる",
      target: "す",
      sourceConjugationGroupValue: ConjugationGroup.IchidanVerb,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Causative
    ),
    Rule(
      source: "さない",
      target: "す",
      sourceConjugationGroupValue: ConjugationGroup.IAdjective,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Negative
    ),
    Rule(
      source: "される",
      target: "す",
      sourceConjugationGroupValue: ConjugationGroup.IchidanVerb,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Passive
    ),
    Rule(
      source: "される",
      target: "する",
      sourceConjugationGroupValue: ConjugationGroup.IchidanVerb,
      targetConjugationGroupValue: ConjugationGroup.SuruVerb,
      reason: DeinflectionReason.Passive
    ),
    Rule(
      source: "しそう",
      target: "す",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Sou
    ),
    Rule(
      source: "しそう",
      target: "する",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.SuruVerb,
      reason: DeinflectionReason.Sou
    ),
    Rule(
      source: "したい",
      target: "す",
      sourceConjugationGroupValue: ConjugationGroup.IAdjective,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Tai
    ),
    Rule(
      source: "したい",
      target: "する",
      sourceConjugationGroupValue: ConjugationGroup.IAdjective,
      targetConjugationGroupValue: ConjugationGroup.SuruVerb,
      reason: DeinflectionReason.Tai
    ),
    Rule(
      source: "したら",
      target: "す",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Tara
    ),
    Rule(
      source: "したら",
      target: "する",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.SuruVerb,
      reason: DeinflectionReason.Tara
    ),
    Rule(
      source: "したり",
      target: "す",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Tari
    ),
    Rule(
      source: "したり",
      target: "する",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.SuruVerb,
      reason: DeinflectionReason.Tari
    ),
    Rule(
      source: "してる",
      target: "す",
      sourceConjugationGroupValue: ConjugationGroup.IchidanVerb,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Continuous
    ),
    Rule(
      source: "してる",
      target: "する",
      sourceConjugationGroupValue: ConjugationGroup.IchidanVerb,
      targetConjugationGroupValue: ConjugationGroup.SuruVerb,
      reason: DeinflectionReason.Continuous
    ),
    Rule(
      source: "しとく",
      target: "す",
      sourceConjugationGroupValue: ConjugationGroup.GodanVerb,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Toku
    ),
    Rule(
      source: "しとく",
      target: "する",
      sourceConjugationGroupValue: ConjugationGroup.GodanVerb,
      targetConjugationGroupValue: ConjugationGroup.SuruVerb,
      reason: DeinflectionReason.Toku
    ),
    Rule(
      source: "しない",
      target: "する",
      sourceConjugationGroupValue: ConjugationGroup.IAdjective,
      targetConjugationGroupValue: ConjugationGroup.SuruVerb,
      reason: DeinflectionReason.Negative
    ),
    Rule(
      source: "します",
      target: "す",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Polite
    ),
    Rule(
      source: "します",
      target: "する",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.SuruVerb,
      reason: DeinflectionReason.Polite
    ),
    Rule(
      source: "しよう",
      target: "する",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.SuruVerb,
      reason: DeinflectionReason.Volitional
    ),
    Rule(
      source: "すぎる",
      target: "い",
      sourceConjugationGroupValue: ConjugationGroup.IchidanVerb,
      targetConjugationGroupValue: ConjugationGroup.IAdjective,
      reason: DeinflectionReason.Sugiru
    ),
    Rule(
      source: "すぎる",
      target: "る",
      sourceConjugationGroupValue: ConjugationGroup.IchidanVerb,
      targetConjugationGroupValue: ConjugationGroup.IchidanVerb | ConjugationGroup.KuruVerb,
      reason: DeinflectionReason.Sugiru
    ),
    Rule(
      source: "そうた",
      target: "そう",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Past
    ),
    Rule(
      source: "そうて",
      target: "そう",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Te
    ),
    Rule(
      source: "たせる",
      target: "つ",
      sourceConjugationGroupValue: ConjugationGroup.IchidanVerb,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Causative
    ),
    Rule(
      source: "たない",
      target: "つ",
      sourceConjugationGroupValue: ConjugationGroup.IAdjective,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Negative
    ),
    Rule(
      source: "たれる",
      target: "つ",
      sourceConjugationGroupValue: ConjugationGroup.IchidanVerb,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Passive
    ),
    Rule(
      source: "ちそう",
      target: "つ",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Sou
    ),
    Rule(
      source: "ちたい",
      target: "つ",
      sourceConjugationGroupValue: ConjugationGroup.IAdjective,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Tai
    ),
    Rule(
      source: "ちます",
      target: "つ",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Polite
    ),
    Rule(
      source: "ちゃう",
      target: "る",
      sourceConjugationGroupValue: ConjugationGroup.GodanVerb,
      targetConjugationGroupValue: ConjugationGroup.IchidanVerb | ConjugationGroup.KuruVerb,
      reason: DeinflectionReason.Chau
    ),
    Rule(
      source: "ったら",
      target: "う",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Tara
    ),
    Rule(
      source: "ったら",
      target: "つ",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Tara
    ),
    Rule(
      source: "ったら",
      target: "る",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Tara
    ),
    Rule(
      source: "ったり",
      target: "う",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Tari
    ),
    Rule(
      source: "ったり",
      target: "つ",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Tari
    ),
    Rule(
      source: "ったり",
      target: "る",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Tari
    ),
    Rule(
      source: "ってる",
      target: "う",
      sourceConjugationGroupValue: ConjugationGroup.IchidanVerb,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Continuous
    ),
    Rule(
      source: "ってる",
      target: "つ",
      sourceConjugationGroupValue: ConjugationGroup.IchidanVerb,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Continuous
    ),
    Rule(
      source: "ってる",
      target: "る",
      sourceConjugationGroupValue: ConjugationGroup.IchidanVerb,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Continuous
    ),
    Rule(
      source: "っとく",
      target: "う",
      sourceConjugationGroupValue: ConjugationGroup.GodanVerb,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Toku
    ),
    Rule(
      source: "っとく",
      target: "つ",
      sourceConjugationGroupValue: ConjugationGroup.GodanVerb,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Toku
    ),
    Rule(
      source: "っとく",
      target: "る",
      sourceConjugationGroupValue: ConjugationGroup.GodanVerb,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Toku
    ),
    Rule(
      source: "ている",
      target: "る",
      sourceConjugationGroupValue: ConjugationGroup.IchidanVerb,
      targetConjugationGroupValue: ConjugationGroup.IchidanVerb | ConjugationGroup.KuruVerb,
      reason: DeinflectionReason.Continuous
    ),
    Rule(
      source: "とうた",
      target: "とう",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Past
    ),
    Rule(
      source: "とうて",
      target: "とう",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Te
    ),
    Rule(
      source: "なさい",
      target: "る",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.IchidanVerb | ConjugationGroup.KuruVerb,
      reason: DeinflectionReason.Nasai
    ),
    Rule(
      source: "なせる",
      target: "ぬ",
      sourceConjugationGroupValue: ConjugationGroup.IchidanVerb,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Causative
    ),
    Rule(
      source: "なない",
      target: "ぬ",
      sourceConjugationGroupValue: ConjugationGroup.IAdjective,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Negative
    ),
    Rule(
      source: "なれる",
      target: "ぬ",
      sourceConjugationGroupValue: ConjugationGroup.IchidanVerb,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Passive
    ),
    Rule(
      source: "にそう",
      target: "ぬ",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Sou
    ),
    Rule(
      source: "にたい",
      target: "ぬ",
      sourceConjugationGroupValue: ConjugationGroup.IAdjective,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Tai
    ),
    Rule(
      source: "にます",
      target: "ぬ",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Polite
    ),
    Rule(
      source: "ばせる",
      target: "ぶ",
      sourceConjugationGroupValue: ConjugationGroup.IchidanVerb,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Causative
    ),
    Rule(
      source: "ばない",
      target: "ぶ",
      sourceConjugationGroupValue: ConjugationGroup.IAdjective,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Negative
    ),
    Rule(
      source: "ばれる",
      target: "ぶ",
      sourceConjugationGroupValue: ConjugationGroup.IchidanVerb,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Passive
    ),
    Rule(
      source: "びそう",
      target: "ぶ",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Sou
    ),
    Rule(
      source: "びたい",
      target: "ぶ",
      sourceConjugationGroupValue: ConjugationGroup.IAdjective,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Tai
    ),
    Rule(
      source: "びます",
      target: "ぶ",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Polite
    ),
    Rule(
      source: "ました",
      target: "る",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.IchidanVerb,
      reason: DeinflectionReason.PolitePast
    ),
    Rule(
      source: "ませる",
      target: "む",
      sourceConjugationGroupValue: ConjugationGroup.IchidanVerb,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Causative
    ),
    Rule(
      source: "ません",
      target: "る",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.IchidanVerb,
      reason: DeinflectionReason.PoliteNegative
    ),
    Rule(
      source: "まない",
      target: "む",
      sourceConjugationGroupValue: ConjugationGroup.IAdjective,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Negative
    ),
    Rule(
      source: "まれる",
      target: "む",
      sourceConjugationGroupValue: ConjugationGroup.IchidanVerb,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Passive
    ),
    Rule(
      source: "みそう",
      target: "む",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Sou
    ),
    Rule(
      source: "みたい",
      target: "む",
      sourceConjugationGroupValue: ConjugationGroup.IAdjective,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Tai
    ),
    Rule(
      source: "みます",
      target: "む",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Polite
    ),
    Rule(
      source: "らせる",
      target: "る",
      sourceConjugationGroupValue: ConjugationGroup.IchidanVerb,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Causative
    ),
    Rule(
      source: "らない",
      target: "る",
      sourceConjugationGroupValue: ConjugationGroup.IAdjective,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Negative
    ),
    Rule(
      source: "られる",
      target: "る",
      sourceConjugationGroupValue: ConjugationGroup.IchidanVerb,
      targetConjugationGroupValue: ConjugationGroup.IchidanVerb | ConjugationGroup.KuruVerb,
      reason: DeinflectionReason.PotentialOrPassive
    ),
    Rule(
      source: "られる",
      target: "る",
      sourceConjugationGroupValue: ConjugationGroup.IchidanVerb,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Passive
    ),
    Rule(
      source: "りそう",
      target: "る",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Sou
    ),
    Rule(
      source: "りたい",
      target: "る",
      sourceConjugationGroupValue: ConjugationGroup.IAdjective,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Tai
    ),
    Rule(
      source: "ります",
      target: "る",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Polite
    ),
    Rule(
      source: "わせる",
      target: "う",
      sourceConjugationGroupValue: ConjugationGroup.IchidanVerb,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Causative
    ),
    Rule(
      source: "わない",
      target: "う",
      sourceConjugationGroupValue: ConjugationGroup.IAdjective,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Negative
    ),
    Rule(
      source: "われる",
      target: "う",
      sourceConjugationGroupValue: ConjugationGroup.IchidanVerb,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Passive
    ),
    Rule(
      source: "んだら",
      target: "ぬ",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Tara
    ),
    Rule(
      source: "んだら",
      target: "ぶ",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Tara
    ),
    Rule(
      source: "んだら",
      target: "む",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Tara
    ),
    Rule(
      source: "んだり",
      target: "ぬ",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Tari
    ),
    Rule(
      source: "んだり",
      target: "ぶ",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Tari
    ),
    Rule(
      source: "んだり",
      target: "む",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Tari
    ),
    Rule(
      source: "んでる",
      target: "ぬ",
      sourceConjugationGroupValue: ConjugationGroup.IchidanVerb,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Continuous
    ),
    Rule(
      source: "んでる",
      target: "ぶ",
      sourceConjugationGroupValue: ConjugationGroup.IchidanVerb,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Continuous
    ),
    Rule(
      source: "んでる",
      target: "む",
      sourceConjugationGroupValue: ConjugationGroup.IchidanVerb,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Continuous
    ),
    Rule(
      source: "んどく",
      target: "ぬ",
      sourceConjugationGroupValue: ConjugationGroup.GodanVerb,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Toku
    ),
    Rule(
      source: "んどく",
      target: "ぶ",
      sourceConjugationGroupValue: ConjugationGroup.GodanVerb,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Toku
    ),
    Rule(
      source: "んどく",
      target: "む",
      sourceConjugationGroupValue: ConjugationGroup.GodanVerb,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Toku
    ),
    Rule(
      source: "行った",
      target: "行く",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Past
    ),
    Rule(
      source: "行って",
      target: "行く",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Te
    ),
    Rule(
      source: "逝った",
      target: "逝く",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Past
    ),
    Rule(
      source: "逝って",
      target: "逝く",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Te
    ),
    Rule(
      source: "往った",
      target: "往く",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Past
    ),
    Rule(
      source: "往って",
      target: "往く",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Te
    ),
    Rule(
      source: "請うた",
      target: "請う",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Past
    ),
    Rule(
      source: "請うて",
      target: "請う",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Te
    ),
    Rule(
      source: "乞うた",
      target: "乞う",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Past
    ),
    Rule(
      source: "乞うて",
      target: "乞う",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Te
    ),
    Rule(
      source: "恋うた",
      target: "恋う",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Past
    ),
    Rule(
      source: "恋うて",
      target: "恋う",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Te
    ),
    Rule(
      source: "問うた",
      target: "問う",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Past
    ),
    Rule(
      source: "問うて",
      target: "問う",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Te
    ),
    Rule(
      source: "負うた",
      target: "負う",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Past
    ),
    Rule(
      source: "負うて",
      target: "負う",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Te
    ),
    Rule(
      source: "沿うた",
      target: "沿う",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Past
    ),
    Rule(
      source: "沿うて",
      target: "沿う",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Te
    ),
    Rule(
      source: "添うた",
      target: "添う",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Past
    ),
    Rule(
      source: "添うて",
      target: "添う",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Te
    ),
    Rule(
      source: "副うた",
      target: "副う",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Past
    ),
    Rule(
      source: "副うて",
      target: "副う",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Te
    ),
    Rule(
      source: "厭うた",
      target: "厭う",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Past
    ),
    Rule(
      source: "厭うて",
      target: "厭う",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Te
    ),
    Rule(
      source: "いた",
      target: "く",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Past
    ),
    Rule(
      source: "いだ",
      target: "ぐ",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Past
    ),
    Rule(
      source: "いて",
      target: "く",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Te
    ),
    Rule(
      source: "いで",
      target: "ぐ",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Te
    ),
    Rule(
      source: "えば",
      target: "う",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Ba
    ),
    Rule(
      source: "える",
      target: "う",
      sourceConjugationGroupValue: ConjugationGroup.IchidanVerb,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Potential
    ),
    Rule(
      source: "おう",
      target: "う",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Volitional
    ),
    Rule(
      source: "仰い",
      target: "仰る",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.MasuStem
    ),
    Rule(
      source: "仰い",
      target: "仰る",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Imperative
    ),
    Rule(
      source: "かず",
      target: "く",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Zu
    ),
    Rule(
      source: "がず",
      target: "ぐ",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Zu
    ),
    Rule(
      source: "かぬ",
      target: "く",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Negative
    ),
    Rule(
      source: "かん",
      target: "く",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Negative
    ),
    Rule(
      source: "がぬ",
      target: "ぐ",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Negative
    ),
    Rule(
      source: "がん",
      target: "ぐ",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Negative
    ),
    Rule(
      source: "きた",
      target: "くる",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.KuruVerb,
      reason: DeinflectionReason.Past
    ),
    Rule(
      source: "きて",
      target: "くる",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.KuruVerb,
      reason: DeinflectionReason.Te
    ),
    Rule(
      source: "くて",
      target: "い",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.IAdjective,
      reason: DeinflectionReason.Te
    ),
    Rule(
      source: "けば",
      target: "く",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Ba
    ),
    Rule(
      source: "げば",
      target: "ぐ",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Ba
    ),
    Rule(
      source: "ける",
      target: "く",
      sourceConjugationGroupValue: ConjugationGroup.IchidanVerb,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Potential
    ),
    Rule(
      source: "げる",
      target: "ぐ",
      sourceConjugationGroupValue: ConjugationGroup.IchidanVerb,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Potential
    ),
    Rule(
      source: "こい",
      target: "くる",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.KuruVerb,
      reason: DeinflectionReason.Imperative
    ),
    Rule(
      source: "こう",
      target: "く",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Volitional
    ),
    Rule(
      source: "ごう",
      target: "ぐ",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Volitional
    ),
    Rule(
      source: "こず",
      target: "くる",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.KuruVerb,
      reason: DeinflectionReason.Zu
    ),
    Rule(
      source: "こぬ",
      target: "くる",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.KuruVerb,
      reason: DeinflectionReason.Negative
    ),
    Rule(
      source: "こん",
      target: "くる",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.KuruVerb,
      reason: DeinflectionReason.Negative
    ),
    Rule(
      source: "さず",
      target: "す",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Zu
    ),
    Rule(
      source: "さぬ",
      target: "す",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Negative
    ),
    Rule(
      source: "さん",
      target: "す",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Negative
    ),
    Rule(
      source: "した",
      target: "す",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Past
    ),
    Rule(
      source: "した",
      target: "する",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.SuruVerb,
      reason: DeinflectionReason.Past
    ),
    Rule(
      source: "して",
      target: "す",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Te
    ),
    Rule(
      source: "して",
      target: "する",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.SuruVerb,
      reason: DeinflectionReason.Te
    ),
    Rule(
      source: "しろ",
      target: "する",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.SuruVerb,
      reason: DeinflectionReason.Imperative
    ),
    Rule(
      source: "せず",
      target: "する",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.SuruVerb,
      reason: DeinflectionReason.Zu
    ),
    Rule(
      source: "せぬ",
      target: "する",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.SuruVerb,
      reason: DeinflectionReason.Negative
    ),
    Rule(
      source: "せん",
      target: "する",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.SuruVerb,
      reason: DeinflectionReason.Negative
    ),
    Rule(
      source: "せば",
      target: "す",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Ba
    ),
    Rule(
      source: "せよ",
      target: "する",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.SuruVerb,
      reason: DeinflectionReason.Imperative
    ),
    Rule(
      source: "せる",
      target: "す",
      sourceConjugationGroupValue: ConjugationGroup.IchidanVerb,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Potential
    ),
    Rule(
      source: "そう",
      target: "い",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.IAdjective,
      reason: DeinflectionReason.Sou
    ),
    Rule(
      source: "そう",
      target: "す",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Volitional
    ),
    Rule(
      source: "そう",
      target: "る",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.IchidanVerb | ConjugationGroup.KuruVerb,
      reason: DeinflectionReason.Sou
    ),
    Rule(
      source: "たい",
      target: "る",
      sourceConjugationGroupValue: ConjugationGroup.IAdjective,
      targetConjugationGroupValue: ConjugationGroup.IchidanVerb | ConjugationGroup.KuruVerb,
      reason: DeinflectionReason.Tai
    ),
    Rule(
      source: "たず",
      target: "つ",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Zu
    ),
    Rule(
      source: "たぬ",
      target: "つ",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Negative
    ),
    Rule(
      source: "たん",
      target: "つ",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Negative
    ),
    Rule(
      source: "たら",
      target: "る",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.IchidanVerb | ConjugationGroup.KuruVerb,
      reason: DeinflectionReason.Tara
    ),
    Rule(
      source: "たり",
      target: "る",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.IchidanVerb | ConjugationGroup.KuruVerb,
      reason: DeinflectionReason.Tari
    ),
    Rule(
      source: "った",
      target: "う",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Past
    ),
    Rule(
      source: "った",
      target: "つ",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Past
    ),
    Rule(
      source: "った",
      target: "る",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Past
    ),
    Rule(
      source: "って",
      target: "う",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Te
    ),
    Rule(
      source: "って",
      target: "つ",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Te
    ),
    Rule(
      source: "って",
      target: "る",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Te
    ),
    Rule(
      source: "てば",
      target: "つ",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Ba
    ),
    Rule(
      source: "てる",
      target: "つ",
      sourceConjugationGroupValue: ConjugationGroup.IchidanVerb,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Potential
    ),
    Rule(
      source: "てる",
      target: "る",
      sourceConjugationGroupValue: ConjugationGroup.IchidanVerb,
      targetConjugationGroupValue: ConjugationGroup.IchidanVerb | ConjugationGroup.KuruVerb,
      reason: DeinflectionReason.Continuous
    ),
    Rule(
      source: "とう",
      target: "つ",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Volitional
    ),
    Rule(
      source: "とく",
      target: "る",
      sourceConjugationGroupValue: ConjugationGroup.GodanVerb,
      targetConjugationGroupValue: ConjugationGroup.IchidanVerb | ConjugationGroup.KuruVerb,
      reason: DeinflectionReason.Toku
    ),
    Rule(
      source: "ない",
      target: "る",
      sourceConjugationGroupValue: ConjugationGroup.IAdjective,
      targetConjugationGroupValue: ConjugationGroup.IchidanVerb | ConjugationGroup.KuruVerb,
      reason: DeinflectionReason.Negative
    ),
    Rule(
      source: "なず",
      target: "ぬ",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Zu
    ),
    Rule(
      source: "なぬ",
      target: "ぬ",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Negative
    ),
    Rule(
      source: "なん",
      target: "ぬ",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Negative
    ),
    Rule(
      source: "ねば",
      target: "ぬ",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Ba
    ),
    Rule(
      source: "ねる",
      target: "ぬ",
      sourceConjugationGroupValue: ConjugationGroup.IchidanVerb,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Potential
    ),
    Rule(
      source: "のう",
      target: "ぬ",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Volitional
    ),
    Rule(
      source: "ばず",
      target: "ぶ",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Zu
    ),
    Rule(
      source: "ばぬ",
      target: "ぶ",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Negative
    ),
    Rule(
      source: "ばん",
      target: "ぶ",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Negative
    ),
    Rule(
      source: "べば",
      target: "ぶ",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Ba
    ),
    Rule(
      source: "べる",
      target: "ぶ",
      sourceConjugationGroupValue: ConjugationGroup.IchidanVerb,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Potential
    ),
    Rule(
      source: "ぼう",
      target: "ぶ",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Volitional
    ),
    Rule(
      source: "ます",
      target: "る",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.IchidanVerb | ConjugationGroup.KuruVerb,
      reason: DeinflectionReason.Polite
    ),
    Rule(
      source: "まず",
      target: "む",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Zu
    ),
    Rule(
      source: "まぬ",
      target: "む",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Negative
    ),
    Rule(
      source: "まん",
      target: "む",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Negative
    ),
    Rule(
      source: "めば",
      target: "む",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Ba
    ),
    Rule(
      source: "める",
      target: "む",
      sourceConjugationGroupValue: ConjugationGroup.IchidanVerb,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Potential
    ),
    Rule(
      source: "もう",
      target: "む",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Volitional
    ),
    Rule(
      source: "よう",
      target: "る",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.IchidanVerb | ConjugationGroup.KuruVerb,
      reason: DeinflectionReason.Volitional
    ),
    Rule(
      source: "らず",
      target: "る",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Zu
    ),
    Rule(
      source: "らぬ",
      target: "る",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Negative
    ),
    Rule(
      source: "らん",
      target: "る",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Negative
    ),
    Rule(
      source: "れば",
      target: "る",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.IchidanVerb | ConjugationGroup.GodanVerb | ConjugationGroup.KuruVerb | ConjugationGroup.SuruVerb,
      reason: DeinflectionReason.Ba
    ),
    Rule(
      source: "れる",
      target: "る",
      sourceConjugationGroupValue: ConjugationGroup.IchidanVerb,
      targetConjugationGroupValue: ConjugationGroup.IchidanVerb | ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Potential
    ),
    Rule(
      source: "ろう",
      target: "る",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Volitional
    ),
    Rule(
      source: "わず",
      target: "う",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Zu
    ),
    Rule(
      source: "わぬ",
      target: "う",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Negative
    ),
    Rule(
      source: "わん",
      target: "う",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Negative
    ),
    Rule(
      source: "んだ",
      target: "ぬ",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Past
    ),
    Rule(
      source: "んだ",
      target: "ぶ",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Past
    ),
    Rule(
      source: "んだ",
      target: "む",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Past
    ),
    Rule(
      source: "んで",
      target: "ぬ",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Te
    ),
    Rule(
      source: "んで",
      target: "ぶ",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Te
    ),
    Rule(
      source: "んで",
      target: "む",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Te
    ),
    Rule(
      source: "い",
      target: "いる",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.IchidanVerb,
      reason: DeinflectionReason.MasuStem
    ),
    Rule(
      source: "い",
      target: "う",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.MasuStem
    ),
    Rule(
      source: "い",
      target: "る",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.KuruVerb,
      reason: DeinflectionReason.Imperative
    ),
    Rule(
      source: "え",
      target: "う",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Imperative
    ),
    Rule(
      source: "え",
      target: "える",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.IchidanVerb,
      reason: DeinflectionReason.MasuStem
    ),
    Rule(
      source: "き",
      target: "きる",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.IchidanVerb,
      reason: DeinflectionReason.MasuStem
    ),
    Rule(
      source: "き",
      target: "く",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.MasuStem
    ),
    Rule(
      source: "き",
      target: "くる",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.KuruVerb,
      reason: DeinflectionReason.MasuStem
    ),
    Rule(
      source: "ぎ",
      target: "ぎる",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.IchidanVerb,
      reason: DeinflectionReason.MasuStem
    ),
    Rule(
      source: "ぎ",
      target: "ぐ",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.MasuStem
    ),
    Rule(
      source: "く",
      target: "い",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.IAdjective,
      reason: DeinflectionReason.Adv
    ),
    Rule(
      source: "け",
      target: "く",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Imperative
    ),
    Rule(
      source: "け",
      target: "ける",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.IchidanVerb,
      reason: DeinflectionReason.MasuStem
    ),
    Rule(
      source: "げ",
      target: "ぐ",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Imperative
    ),
    Rule(
      source: "げ",
      target: "げる",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.IchidanVerb,
      reason: DeinflectionReason.MasuStem
    ),
    Rule(
      source: "さ",
      target: "い",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.IAdjective,
      reason: DeinflectionReason.Noun
    ),
    Rule(
      source: "し",
      target: "す",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.MasuStem
    ),
    Rule(
      source: "じ",
      target: "じる",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.IchidanVerb,
      reason: DeinflectionReason.MasuStem
    ),
    Rule(
      source: "ず",
      target: "る",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.IchidanVerb | ConjugationGroup.KuruVerb,
      reason: DeinflectionReason.Zu
    ),
    Rule(
      source: "せ",
      target: "す",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Imperative
    ),
    Rule(
      source: "せ",
      target: "せる",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.IchidanVerb,
      reason: DeinflectionReason.MasuStem
    ),
    Rule(
      source: "ぜ",
      target: "ぜる",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.IchidanVerb,
      reason: DeinflectionReason.MasuStem
    ),
    Rule(
      source: "た",
      target: "る",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.IchidanVerb | ConjugationGroup.KuruVerb,
      reason: DeinflectionReason.Past
    ),
    Rule(
      source: "ち",
      target: "ちる",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.IchidanVerb,
      reason: DeinflectionReason.MasuStem
    ),
    Rule(
      source: "ち",
      target: "つ",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.MasuStem
    ),
    Rule(
      source: "て",
      target: "つ",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Imperative
    ),
    Rule(
      source: "て",
      target: "てる",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.IchidanVerb,
      reason: DeinflectionReason.MasuStem
    ),
    Rule(
      source: "て",
      target: "る",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.IchidanVerb | ConjugationGroup.KuruVerb,
      reason: DeinflectionReason.Te
    ),
    Rule(
      source: "で",
      target: "でる",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.IchidanVerb,
      reason: DeinflectionReason.MasuStem
    ),
    Rule(
      source: "な",
      target: "",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.IchidanVerb | ConjugationGroup.GodanVerb | ConjugationGroup.KuruVerb | ConjugationGroup.SuruVerb,
      reason: DeinflectionReason.ImperativeNegative
    ),
    Rule(
      source: "に",
      target: "にる",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.IchidanVerb,
      reason: DeinflectionReason.MasuStem
    ),
    Rule(
      source: "に",
      target: "ぬ",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.MasuStem
    ),
    Rule(
      source: "ぬ",
      target: "る",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.IchidanVerb,
      reason: DeinflectionReason.Negative
    ),
    Rule(
      source: "ん",
      target: "る",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.IchidanVerb,
      reason: DeinflectionReason.Negative
    ),
    Rule(
      source: "ね",
      target: "ぬ",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Imperative
    ),
    Rule(
      source: "ね",
      target: "ねる",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.IchidanVerb,
      reason: DeinflectionReason.MasuStem
    ),
    Rule(
      source: "ひ",
      target: "ひる",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.IchidanVerb,
      reason: DeinflectionReason.MasuStem
    ),
    Rule(
      source: "び",
      target: "びる",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.IchidanVerb,
      reason: DeinflectionReason.MasuStem
    ),
    Rule(
      source: "び",
      target: "ぶ",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.MasuStem
    ),
    Rule(
      source: "へ",
      target: "へる",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.IchidanVerb,
      reason: DeinflectionReason.MasuStem
    ),
    Rule(
      source: "べ",
      target: "ぶ",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Imperative
    ),
    Rule(
      source: "べ",
      target: "べる",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.IchidanVerb,
      reason: DeinflectionReason.MasuStem
    ),
    Rule(
      source: "み",
      target: "みる",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.IchidanVerb,
      reason: DeinflectionReason.MasuStem
    ),
    Rule(
      source: "み",
      target: "む",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.MasuStem
    ),
    Rule(
      source: "め",
      target: "む",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Imperative
    ),
    Rule(
      source: "め",
      target: "める",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.IchidanVerb,
      reason: DeinflectionReason.MasuStem
    ),
    Rule(
      source: "よ",
      target: "る",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.IchidanVerb,
      reason: DeinflectionReason.Imperative
    ),
    Rule(
      source: "り",
      target: "りる",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.IchidanVerb,
      reason: DeinflectionReason.MasuStem
    ),
    Rule(
      source: "り",
      target: "る",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.MasuStem
    ),
    Rule(
      source: "れ",
      target: "る",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.GodanVerb,
      reason: DeinflectionReason.Imperative
    ),
    Rule(
      source: "れ",
      target: "れる",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.IchidanVerb,
      reason: DeinflectionReason.MasuStem
    ),
    Rule(
      source: "ろ",
      target: "る",
      sourceConjugationGroupValue: ConjugationGroup.NotResultOfAnyDeinflection,
      targetConjugationGroupValue: ConjugationGroup.IchidanVerb,
      reason: DeinflectionReason.Imperative
    )
]
