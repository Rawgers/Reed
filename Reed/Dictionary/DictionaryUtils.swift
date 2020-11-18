//
//  Utils.swift
//  Reed
//
//  Created by Roger Luo on 10/1/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import CoreData

func isKana(_ string: String) -> Bool {
    for char in string {
        if !isKana(char) {
            return false
        }
    }
    return true
}

func isKana(_ char: Character) -> Bool {
    let charScalar = char.unicodeScalars.map { $0.value }.reduce(0, +)
    
    // https://www.key-shortcut.com/en/writing-systems/ひらがな-japanese
    return charScalar >= 0x3040 && charScalar <= 0x309f
        || charScalar >= 0x30a0 && charScalar <= 0x30ff
}
