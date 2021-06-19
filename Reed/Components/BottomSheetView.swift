//
//  BottomSheetView.swift
//  Reed
//
//  Created by Hugo Zhan on 11/7/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import SwiftUI

struct BottomSheetView<Content: View>: View {
    @Binding var isOpen: Bool
    
    let minHeight: CGFloat
    let maxHeight: CGFloat
    let content: Content
    
    init(isOpen: Binding<Bool>, @ViewBuilder content: () -> Content) {
        self.minHeight = DefinerConstants.BOTTOM_SHEET_MIN_HEIGHT
        self.maxHeight = DefinerConstants.BOTTOM_SHEET_MAX_HEIGHT
        self.content = content()
        self._isOpen = isOpen
    }
    
    private var offset: CGFloat {
        isOpen ? 0 : maxHeight - minHeight
    }
    
    private var indicator: some View {
        RoundedRectangle(cornerRadius: DefinerConstants.BOTTOM_SHEET_CORNER_RADIUS)
            .fill(Color(.systemGray4))
            .frame(
                width: DefinerConstants.BOTTOM_SHEET_INDICATOR_WIDTH,
                height: DefinerConstants.BOTTOM_SHEET_INDICATOR_HEIGHT
            )
    }
    
    @GestureState private var translation: CGFloat = 0
    @Environment(\.colorScheme) var colorScheme
    
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
            .shadow(radius: 4)
            .frame(height: geometry.size.height, alignment: .bottom)
            .offset(y: max(self.offset + self.translation, 0))
            .animation(.interactiveSpring())
            .gesture(
                DragGesture().updating(self.$translation) { value, state, _ in
                    state = value.translation.height
                }.onEnded { value in
                    let snapDistance = self.maxHeight * DefinerConstants.BOTTOM_SHEET_SNAP_RATIO
                    guard abs(value.translation.height) > snapDistance else {
                        return
                    }
                    self.isOpen = value.translation.height < 0
                }
            )
        }
    }
}
