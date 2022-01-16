//
//  BottomSheetView.swift
//  Reed
//
//  Created by Hugo Zhan on 11/7/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import SwiftUI

struct BottomSheet<Content: View>: View {
    @Environment(\.colorScheme) var colorScheme
    @GestureState private var translation: CGFloat = 0
    @State private var isOpen: Bool = false
    
    let minHeight: CGFloat
    let maxHeight: CGFloat
    let toggleDisplayMode: () -> Void
    let content: () -> Content
    private var offset: CGFloat {
        isOpen ? 0 : maxHeight - minHeight
    }
    
    init(
        toggleDisplayMode: @escaping () -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.minHeight = DefinerConstants.BOTTOM_SHEET_MIN_HEIGHT
        self.maxHeight = DefinerConstants.BOTTOM_SHEET_MAX_HEIGHT
        self.toggleDisplayMode = toggleDisplayMode
        self.content = content
    }
    
    private var indicator: some View {
        if isOpen {
            return AnyView(Image(systemName: "chevron.compact.down")
                .imageScale(.medium)
                .animation(
                    .interactiveSpring(
                        response: 0.25,
                        dampingFraction: 0.75
                    ),
                    value: isOpen
                )
            )
        } else {
            return AnyView(VStack {
                Image(systemName: "chevron.compact.up")
                    .imageScale(.medium)
                Image(systemName: "chevron.compact.down")
                    .imageScale(.medium)
            })
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                indicator
                    .foregroundColor(Color(UIColor.systemGray2))
                    .padding(.top, 8)
                self.content()
            }
            .frame(width: geometry.size.width, height: self.maxHeight, alignment: .top)
            .background(
                colorScheme == .dark
                    ? Color(.secondarySystemBackground)
                    : Color(.systemBackground)
            )
            .cornerRadius(DefinerConstants.BOTTOM_SHEET_CORNER_RADIUS)
            .shadow(radius: DefinerConstants.BOTTOM_SHEET_SHADOW_RADIUS)
            .frame(height: geometry.size.height, alignment: .bottom)
            .offset(y: max(self.offset + self.translation, 0))
            .animation(
                .interactiveSpring(
                    response: 0.25,
                    dampingFraction: 0.75
                ),
                value: self.translation
            )
            .gesture(
                DragGesture().updating(self.$translation) { value, state, _ in
                    state = value.translation.height
                }.onEnded { value in
                    let snapDistance = self.maxHeight * DefinerConstants.BOTTOM_SHEET_SNAP_RATIO
                    let screenHeight = UIScreen.main.bounds.size.height
                    if value.predictedEndLocation.y >= screenHeight - minHeight {
                        self.toggleDisplayMode()
                    }
                    if abs(value.translation.height) > snapDistance {
                        self.isOpen = value.translation.height < 0
                    }
                }
            )
        }
    }
}
