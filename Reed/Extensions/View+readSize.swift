//
//  View+readSize.swift
//  Reed
//
//  Created by Roger Luo on 11/26/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import SwiftUI

// https://fivestars.blog/swiftui/swiftui-share-layout-information.html
extension View {
    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geometryProxy in
                Color.clear
                  .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
            }
        )
        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
}

private struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}
