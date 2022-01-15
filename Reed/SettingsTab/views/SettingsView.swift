//
//  SettingsView.swift
//  Reed
//
//  Created by Roger Luo on 9/9/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    
    var body: some View {
        VStack {
            Button("BIG SWAG") {
                print("BIG SWAG")
            }
            List(viewModel.titles, id: \.self) { titleTokens in
                FlexView(data: titleTokens, spacing: 0, alignment: .leading) { token in
                    Text(token.text)
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
