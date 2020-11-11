//
//  DefinitionModal.swift
//  Reed
//
//  Created by Roger Luo on 9/9/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import SwiftUI

struct DefinitionView: View {
    @ObservedObject var viewModel: DefinitionViewModel
    
    var body: some View {
        ZStack {
            Color.white
            ScrollView {
                Spacer()
                Text(viewModel.content)
                    .frame(width: UIScreen.main.bounds.width * 0.6, alignment: .topLeading)
                    .lineLimit(nil)
                    .fixedSize(horizontal: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/, vertical: false)
                Spacer()
            }
        }
    }
}

struct DefinitionModal_Previews: PreviewProvider {
    static var previews: some View {
        DefinitionView(viewModel: DefinitionViewModel())
    }
}
