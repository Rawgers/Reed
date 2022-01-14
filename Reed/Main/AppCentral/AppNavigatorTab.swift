//
//  AppNavigatorButton.swift
//  Reed
//
//  Created by Roger Luo on 7/21/21.
//  Copyright © 2021 Roger Luo. All rights reserved.
//

import SwiftUI

struct AppNavigatorTabButtonStyle: PrimitiveButtonStyle {
    @State private var pressed = false
    let isSelected: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(isSelected ? .blue : .primary)
            .opacity(self.pressed ? 0.5 : 1.0)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged({ _ in
                        withAnimation(.easeIn) {
                            self.pressed = true
                        }
                    })
                    .onEnded({ _ in
                        withAnimation() {
                            self.pressed = false
                        }
                        configuration.trigger()
                    })
            )
    }
}

struct AppNavigatorTab: View {
    let title: String
    let iconName: String
    let tag: Int
    @Binding var selectedTab: Int
    
    init(title: String, iconName: String, tag: Int, selectedTab: Binding<Int>) {
        self.title = title
        self.iconName = iconName
        self.tag = tag
        self._selectedTab = selectedTab
    }
    
    var body: some View {
        Button(action: {
            selectedTab = tag
        }) {
            VStack(spacing: 4) {
                Circle()
                    .frame(width: 48, height: 48)
                    .foregroundColor(Color(UIColor.systemGray5))
                    .overlay(
                        Image(systemName: iconName)
                            .imageScale(.medium)
                    )
                Text(self.title)
                    .font(.footnote)
                    .foregroundColor(.primary)
            }
        }
        .buttonStyle(AppNavigatorTabButtonStyle(isSelected: selectedTab == tag))
        .frame(maxWidth: .infinity)
    }
}

struct AppNavigatorButton_Previews: PreviewProvider {
    static var previews: some View {
        AppNavigatorTab(
            title: "Library",
            iconName: "books.vertical",
            tag: 0,
            selectedTab: .constant(0)
        )
    }
}
