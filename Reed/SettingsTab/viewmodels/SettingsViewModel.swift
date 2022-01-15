//
//  SettingsViewModel.swift
//  Reed
//
//  Created by Roger Luo on 1/14/22.
//  Copyright © 2022 Roger Luo. All rights reserved.
//

import Foundation
import SwiftyNarou

struct FlexViewToken: Hashable {
    let id = UUID()
    let text: String
}

class SettingsViewModel: ObservableObject {
    let CONTENT = "月からきたうさぎさんがおたんじょうびにもらった手紙のおはなし"
    
    @Published var titles: [[FlexViewToken]] = []
    
    init() {
        let narouRequest = createNarouRequest()
        Narou.fetchNarouApi(request: narouRequest) { data, _ in
            // main thread
            guard let data = data else { return }
            let titles = data.1.map { novel in novel.title }
            
            let tokenizer = Tokenizer()
            DispatchQueue.global(qos: .userInitiated).async {
                let tokenizedTitles = titles.map { title in tokenizer.tokenize(title ?? "") }
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                    self.titles = tokenizedTitles.map { tokenizedTitle in
                        tokenizedTitle.map { token in
                            FlexViewToken(text: token.surface)
                }}}
            }
        }
    }
    
    func createNarouRequest() -> NarouRequest {
        NarouRequest(
            responseFormat: NarouResponseFormat(
                gzipCompressionLevel: 5,
                fileFormat: .JSON,
                fields: [.ncode, .novelTitle, .author, .subgenre, .synopsis],
                limit: 40,
                startIndex: 0,
                order: .mostPopularWeek
            )
        )
    }
}
