//
//  SettingsView.swift
//  Reed
//
//  Created by Roger Luo on 9/9/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        GeometryReader { proxy in
            Rectangle()
                .frame(width: proxy.size.width, height: proxy.size.height)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
