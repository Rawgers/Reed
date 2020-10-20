//
//  DefinitionModal.swift
//  Reed
//
//  Created by Roger Luo on 9/9/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import SwiftUI


struct DefinitionModal: View {
    @EnvironmentObject var wordSelection: Word

    var body: some View {
        ZStack {
            Color.gray
            Text(self.wordSelection.word)
        }
        .edgesIgnoringSafeArea(.vertical)
    }
}

struct DefinitionModal_Previews: PreviewProvider {
    static var previews: some View {
        DefinitionModal().environmentObject(Word())
    }
}

class Word: ObservableObject {
    @Published var word: String = ""
}
