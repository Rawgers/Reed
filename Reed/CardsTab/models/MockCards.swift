//
//  MockCards.swift
//  Reed
//
//  Created by Roger Luo on 9/9/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import Foundation

class MockCards {
    static let word: [String] = [
        "現実",
        "助ける",
        "絶対",
    ]
    
    static let reading: [String] = [
        "げんじつ",
        "たすける",
        "ぜったい"
    ]
    
    static let definitions: [[String]] = [
        [
            "reality; actuality; hard fact"
        ],
        [
            "to save; to rescue​",
            "to help; to assist​",
            "to support (financially); to contribute (to); to provide aid​",
            "to facilitate; to stimulate; to promote; to contribute to​",
        ],
        [
            "definitely; absolutely; unconditionally",
            "absolute; unconditional; unmistakable​"
        ],
    ]
    
    static let savedContexts: [[String]] = [
        [
            "現実を見てください。",
            "ゲームをしすぎると現実とファンタジーの区別がつかなくなる。"
        ],
        [
            "困ったらこの私が助ける！"
        ],
        [
            "あいつなら絶対間に合うから…"
        ],
    ]
}
