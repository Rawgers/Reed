//
//  SettingsView.swift
//  Reed
//
//  Created by Roger Luo on 9/9/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @GestureState private var dragOffset: CGFloat = 0
    @State private var isContentScrollable: Bool = true
    
    init() {
        print("init settingsview")
    }
    
    /// represents DefinerTab contents
    private var bottomSheetContent: some View {
        ScrollView(isContentScrollable ? .vertical : []) {
            LinearGradient(
                gradient: Gradient(colors: [.orange, .purple]),
                startPoint: .top,
                endPoint: .bottom
            )
                .frame(
                    width: UIScreen.main.bounds.width,
                    height: UIScreen.main.bounds.height
                )
                .padding(.horizontal)
        }
        .frame(
            width: UIScreen.main.bounds.width,
            height: UIScreen.main.bounds.height / 2
        )
    }
    
    private var indicator: some View {
        Color.blue
            .frame(width: UIScreen.main.bounds.width, height: 50)
    }
    
    private var bottomSheet: some View {
        VStack(spacing: 0) {
            indicator
            bottomSheetContent
        }
        .cornerRadius(10)
        .offset(y: min(dragOffset, 150))
    }
    
    private var bottomSheetWithDragGesture: some View {
        bottomSheet
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            /// represents the content
            Color.mint
                .frame(
                    width: UIScreen.main.bounds.width,
                    height: UIScreen.main.bounds.height
                )
            bottomSheetWithDragGesture
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
