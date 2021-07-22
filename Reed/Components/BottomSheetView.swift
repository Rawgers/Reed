//
//  BottomSheetView.swift
//  Reed
//
//  Created by Hugo Zhan on 11/7/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import SwiftUI

struct BottomSheetView<Content: View>: View {
    @Environment(\.colorScheme) var colorScheme
    @GestureState private var translation: CGFloat = 0
    @Binding var isOpen: Bool
    
    let minHeight: CGFloat
    let maxHeight: CGFloat
    let content: Content
    private var offset: CGFloat {
        isOpen ? 0 : maxHeight - minHeight
    }
    
    init(isOpen: Binding<Bool>, @ViewBuilder content: () -> Content) {
        self.minHeight = DefinerConstants.BOTTOM_SHEET_MIN_HEIGHT
        self.maxHeight = DefinerConstants.BOTTOM_SHEET_MAX_HEIGHT
        self.content = content()
        self._isOpen = isOpen
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
                self.content
            }
            .frame(width: geometry.size.width, height: self.maxHeight, alignment: .top)
            .background(
                colorScheme == .dark
                    ? Color(.secondarySystemBackground)
                    : Color.white
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
                    if abs(value.translation.height) > snapDistance {
                        self.isOpen = value.translation.height < 0
                    }
                }
            )
        }
    }
}
