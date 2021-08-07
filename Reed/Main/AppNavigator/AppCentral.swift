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

class DefinerResults: ObservableObject {
    @Published var entries = [DefinitionDetails]()
    
    func updateEntries(newEntries: [DefinitionDetails]) {
        self.entries = newEntries
    }
}

struct AppCentral: View {
    @StateObject private var definerResults = DefinerResults()
    @State private var selectedTab: Int = 0
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
            VStack(alignment: .center) {
                AppNavigatorInternalTabs(
                    selectedTab: $selectedTab,
                    tabViewTypes: tabViewTypes
                )
                
                Rectangle()
                    .frame(height: DefinerConstants.BOTTOM_SHEET_MIN_HEIGHT)
                    .opacity(0)
            }
            
            BottomSheet(
                toggleDisplayMode: toggleBottomSheetDisplayMode
            ) {
                switch displayType {
                case .navigation:
                    AppNavigator
                case .definer:
                    Definer(entries: $definerResults.entries)
                }
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .environmentObject(definerResults)
        .introspectTabBarController { tabBarController in
            tabBarController.tabBar.isHidden = true
        }
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
