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
    static let PLACEHOLDER_RECTANGLE_HEIGHT = BOTTOM_SHEET_MIN_HEIGHT - BOTTOM_SHEET_SHADOW_RADIUS * 2
}

private struct DefinerAndAppNavigator: View {
    @EnvironmentObject var appState: AppState
    @State private var bottomSheetDisplayType: BottomSheetDisplayType = .navigation
    @Binding var entries: [DefinitionDetails]
    
    var body: some View {
        BottomSheet(toggleDisplayMode: toggleBottomSheetDisplayMode) {
            switch bottomSheetDisplayType {
            case .navigation:
                AppNavigator(
                    selectedTab: $appState.selectedTab,
                    bottomSheetDisplayType: $bottomSheetDisplayType,
                    entries: $entries
                )
            case .definer:
                Definer(entries: $entries)
            }
        }
    }
    
    func toggleBottomSheetDisplayMode() {
        bottomSheetDisplayType = bottomSheetDisplayType == .navigation
            ? .definer
            : .navigation
    }
}

private struct DefinerAndAppNavigatorBottomSheet: ViewModifier {
    @Binding var entries: [DefinitionDetails]
    let isNavigationBarHidden: Bool // true for custom nav bar behavior
    
    init(
        entries: Binding<[DefinitionDetails]>,
        isNavigationBarHidden: Bool = false
    ) {
        self._entries = entries
        self.isNavigationBarHidden = isNavigationBarHidden
    }
    
    func body(content: Content) -> some View {
        ZStack {
            VStack(alignment: .center) {
                content
                Rectangle()
                    .frame(height: DefinerConstants.PLACEHOLDER_RECTANGLE_HEIGHT)
                    .opacity(0)
            }
            .navigationBarHidden(isNavigationBarHidden)
            
            DefinerAndAppNavigator(entries: $entries)
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

extension View {
    func addDefinerAndAppNavigator(entries: Binding<[DefinitionDetails]>) -> some View {
        modifier(DefinerAndAppNavigatorBottomSheet(entries: entries))
    }
}
