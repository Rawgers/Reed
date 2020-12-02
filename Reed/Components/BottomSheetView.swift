//
//  BottomSheetView.swift
//  Reed
//
//  Created by Hugo Zhan on 11/7/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import SwiftUI

fileprivate enum Constants {
    static let radius: CGFloat = 16
    static let indicatorHeight: CGFloat = 2
    static let indicatorWidth: CGFloat = 32
    static let snapRatio: CGFloat = 0.25
    static let minHeight: CGFloat = 120
    static let maxHeight: CGFloat = UIScreen.main.bounds.height * 0.4
}

struct BottomSheetView<Content: View>: View {
    @Binding var isOpen: Bool
    
    let maxHeight: CGFloat
    let minHeight: CGFloat
    let content: Content
    
    init(isOpen: Binding<Bool>, @ViewBuilder content: () -> Content) {
        self.minHeight = Constants.minHeight
        self.maxHeight = Constants.maxHeight
        self.content = content()
        self._isOpen = isOpen
    }
    
    private var offset: CGFloat {
        isOpen ? 0 : maxHeight - minHeight
    }
    
    private var indicator: some View {
        RoundedRectangle(cornerRadius: Constants.radius)
            .fill(Color(.systemGray4))
            .frame(
                width: Constants.indicatorWidth,
                height: Constants.indicatorHeight
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
            .background(colorScheme == .dark ? Color(.secondarySystemBackground) : Color.white)
            .cornerRadius(Constants.radius)
            .shadow(radius: 4)
            .frame(height: geometry.size.height, alignment: .bottom)
            .offset(y: max(self.offset + self.translation, 0))
            .animation(.interactiveSpring())
            .gesture(
                DragGesture().updating(self.$translation) { value, state, _ in
                    state = value.translation.height
                }.onEnded { value in
                    let snapDistance = self.maxHeight * Constants.snapRatio
                    guard abs(value.translation.height) > snapDistance else {
                        return
                    }
                    self.isOpen = value.translation.height < 0
                }
            )
        }
    }
}
