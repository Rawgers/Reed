//
//  AppNavigator.swift
//  Reed
//
//  Created by Roger Luo on 7/21/21.
//  Copyright © 2021 Roger Luo. All rights reserved.
//

import SwiftUI

enum BottomSheetDisplay {
    case navigation
    case definer
}

struct AppCentral: View {
    @State private var selectedTab: Int = 0
    @State private var entries = [DefinitionDetails]()
    @State private var displayType: BottomSheetDisplay = .navigation
    let tabViewTypes: [Any] = [
        LibraryView.self,
        DiscoverView.self,
        VocabularyListView.self,
        SettingsView.self
    ]
    
    private var AppNavigator: some View {
        HStack {
            AppNavigatorTab(
                title: "Library",
                iconName: "books.vertical",
                tag: 0,
                selectedTab: $selectedTab
            )
            AppNavigatorTab(
                title: "Discover",
                iconName: "magnifyingglass",
                tag: 1,
                selectedTab: $selectedTab
            )
//                    AppNavigatorTab(
//                        title: "Cards",
//                        iconName: "rectangle.grid.2x2",
//                        tag: 2,
//                        selectedTab: $selectedTab
//                    )
//                    AppNavigatorTab(
//                        title: "Settings",
//                        iconName: "wrench",
//                        tag: 3,
//                        selectedTab: $selectedTab
//                    )
        }
        .padding(.top)
    }
    
    var body: some View {
        ZStack {
            AppNavigatorInternalTabs(
                selectedTab: $selectedTab,
                tabViewTypes: tabViewTypes
            )
            
            BottomSheet(
                isOpen: .constant(false),
                toggleDisplayMode: toggleBottomSheetDisplayMode
            ) {
                switch displayType {
                case .navigation:
                    AppNavigator
                case .definer:
                    Definer(
                        entries: $entries,
                        toggleDisplayMode: toggleBottomSheetDisplayMode
                    )
                }
            }
        }
        .ignoresSafeArea(edges: .bottom)
    }
    
    func toggleBottomSheetDisplayMode() {
        displayType = displayType == .navigation ? .definer : .navigation
    }
}


struct AppNavigator_Previews: PreviewProvider {
    static var previews: some View {
        AppCentral()
    }
}
