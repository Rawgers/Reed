//
//  Mecab.swift
//  Reed
//
//  Created by Shiori Yamashita on 2020/11/02.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

let DEFAULT_JAPANESE_RESOURCES_BUNDLE_NAME = "mecab-naist-jdic-utf-8"

class MecabWrapper {
    let mecab: Mecab

    init() {
        let jpBundlePath = Bundle.main.path(forResource: DEFAULT_JAPANESE_RESOURCES_BUNDLE_NAME, ofType: "bundle")
        let jpBundleResourcePath = Bundle.init(path: jpBundlePath!)!.resourcePath
        mecab = Mecab.init(dicDirPath: jpBundleResourcePath!)
    }
}
