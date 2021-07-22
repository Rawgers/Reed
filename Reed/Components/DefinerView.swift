//
//  DefinerView.swift
//  Reed
//
//  Created by Roger Luo on 6/19/21.
//  Copyright © 2021 Roger Luo. All rights reserved.
//

import SwiftUI

enum DefinerConstants {
    static let BOTTOM_SHEET_MIN_HEIGHT: CGFloat = 120
    static let BOTTOM_SHEET_MAX_HEIGHT: CGFloat = UIScreen.main.bounds.height * 0.4
    static let BOTTOM_SHEET_CORNER_RADIUS: CGFloat = 10
    static let BOTTOM_SHEET_SHADOW_RADIUS: CGFloat = 4
    static let BOTTOM_SHEET_INDICATOR_WIDTH: CGFloat = 36
    static let BOTTOM_SHEET_INDICATOR_HEIGHT: CGFloat = 5
    static let BOTTOM_SHEET_SNAP_RATIO: CGFloat = 0.25
    static let CONTENT_WIDTH: CGFloat = UIScreen.main.bounds.width - 32
    static let CONTENT_HEIGHT: CGFloat = UIScreen.main.bounds.height
        - (BOTTOM_SHEET_MAX_HEIGHT - BOTTOM_SHEET_MIN_HEIGHT) - 32
    static let NOVEL_SYNOPSIS_PRELOAD_HEIGHT: CGFloat = 5 * CONTENT_HEIGHT
}

struct DefinerView<Content:View>: View {
    let isNavigationBarHidden: Bool // true for custom nav bar behavior
    @Binding var entries: [DefinitionDetails]
    let content: Content
    
    init(
        entries: Binding<[DefinitionDetails]>,
        isNavigationBarHidden: Bool,
        @ViewBuilder content: () -> Content
    ) {
        self._entries = entries
        self.isNavigationBarHidden = isNavigationBarHidden
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                self.content
                
                Rectangle()
                    .frame(height: DefinerConstants.BOTTOM_SHEET_MIN_HEIGHT)
                    .opacity(0)
            }
            .padding(.horizontal)
            .ignoresSafeArea(edges: .bottom)
            .background(Color(.systemBackground))
            .navigationBarHidden(isNavigationBarHidden)
            
            Definer(entries: $entries)
        }
    }
}

struct DefinerView_Previews: PreviewProvider {
    static var previews: some View {
        DefinerView(
            entries: .constant([DefinitionDetails]()),
            isNavigationBarHidden: false
        ) {
            EmptyView()
        }
    }
}
