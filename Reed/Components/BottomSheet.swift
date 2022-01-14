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
        RoundedRectangle(cornerRadius: DefinerConstants.BOTTOM_SHEET_CORNER_RADIUS)
            .fill(Color(.systemGray4))
            .frame(
                width: DefinerConstants.BOTTOM_SHEET_INDICATOR_WIDTH,
                height: DefinerConstants.BOTTOM_SHEET_INDICATOR_HEIGHT
            )
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                self.indicator.padding(.top, 8)
                self.content()
            }
            .frame(width: geometry.size.width, height: self.maxHeight, alignment: .top)
            .background(
                Color(.secondarySystemBackground)
            )
            .cornerRadius(DefinerConstants.BOTTOM_SHEET_CORNER_RADIUS)
            .shadow(radius: DefinerConstants.BOTTOM_SHEET_SHADOW_RADIUS)
            .frame(height: geometry.size.height, alignment: .bottom)
            .offset(y: max(self.offset + self.translation, 0))
            .animation(.interactiveSpring(response: 0.25, dampingFraction: 0.75))
            .gesture(
                DragGesture().updating(self.$translation) { value, state, _ in
                    state = value.translation.height
                }.onEnded { value in
                    let snapDistance = self.maxHeight * DefinerConstants.BOTTOM_SHEET_SNAP_RATIO
                    let screenHeight = UIScreen.main.bounds.size.height
                    if value.location.y > screenHeight - minHeight
                        && value.predictedEndLocation.y >= screenHeight - 10 {
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
