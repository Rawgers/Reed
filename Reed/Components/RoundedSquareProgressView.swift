//
//  RoundedSquareProgressView.swift
//  Reed
//
//  Created by Hugo Zhan on 1/15/22.
//  Copyright © 2022 Roger Luo. All rights reserved.
//

import Foundation
import SwiftUI

struct RoundedSquareProgressViewStyle: ProgressViewStyle {
    @Environment(\.colorScheme) var colorScheme

    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 86, height: 86)
                .foregroundColor(
                    colorScheme == .dark
                        ? Color(.systemBackground)
                        : Color(.secondarySystemBackground)
                )
                .opacity(0.25)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10))
            ProgressView(configuration)
                .scaleEffect(x: 2, y: 2, anchor: .center)
        }
    }
}

struct RoundedSquareProgressView: View {
    var body: some View {
        ProgressView()
            .progressViewStyle(RoundedSquareProgressViewStyle())
    }
}
