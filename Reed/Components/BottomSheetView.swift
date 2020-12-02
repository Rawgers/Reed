//
//  BottomSheetView.swift
//  Reed
//
//  Created by Hugo Zhan on 11/7/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import SwiftUI

enum BottomSheetConstants {
    static let minHeight: CGFloat = 120
    static let maxHeight: CGFloat = UIScreen.main.bounds.height * 0.4
    fileprivate static let radius: CGFloat = 16
    fileprivate static let indicatorHeight: CGFloat = 2
    fileprivate static let indicatorWidth: CGFloat = 32
    fileprivate static let snapRatio: CGFloat = 0.25
}

struct BottomSheetView<Content: View>: View {
    @Binding var isOpen: Bool
    
    let minHeight: CGFloat
    let maxHeight: CGFloat
    let content: Content
    
    init(isOpen: Binding<Bool>, @ViewBuilder content: () -> Content) {
        self.minHeight = BottomSheetConstants.minHeight
        self.maxHeight = BottomSheetConstants.maxHeight
        self.content = content()
        self._isOpen = isOpen
    }
    
    private var offset: CGFloat {
        isOpen ? 0 : maxHeight - minHeight
    }
    
    private var indicator: some View {
        RoundedRectangle(cornerRadius: BottomSheetConstants.radius)
            .fill(Color(.systemGray4))
            .frame(
                width: BottomSheetConstants.indicatorWidth,
                height: BottomSheetConstants.indicatorHeight
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
            .cornerRadius(BottomSheetConstants.radius)
            .shadow(radius: 4)
            .frame(height: geometry.size.height, alignment: .bottom)
            .offset(y: max(self.offset + self.translation, 0))
            .animation(.interactiveSpring())
            .gesture(
                DragGesture().updating(self.$translation) { value, state, _ in
                    state = value.translation.height
                }.onEnded { value in
                    let snapDistance = self.maxHeight * BottomSheetConstants.snapRatio
                    guard abs(value.translation.height) > snapDistance else {
                        return
                    }
                    self.isOpen = value.translation.height < 0
                }
            )
        }
    }
}
