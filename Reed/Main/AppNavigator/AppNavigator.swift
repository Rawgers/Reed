//
//  AppNavigator.swift
//  Reed
//
//  Created by Roger Luo on 7/21/21.
//  Copyright © 2021 Roger Luo. All rights reserved.
//

import SwiftUI

struct AppNavigator: View {
    @State private var selectedTab: Int = 0
    let tabViewTypes: [Any] = [
        LibraryView.self,
        DiscoverView.self,
        VocabularyListView.self,
        SettingsView.self
    ]
    
    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                ForEach(0 ..< tabViewTypes.endIndex) { i in
                    buildView(types: tabViewTypes, index: i)
                        .edgesIgnoringSafeArea(.bottom)
                        .tag(i)
                }
            }
            .introspectTabBarController { UITabBarController in
                UITabBarController.tabBar.isHidden = true
            }
            
            BottomSheetView(isOpen: .constant(false)) {
                HStack() {
                    AppNavigatorButton(
                        title: "Library",
                        iconName: "books.vertical",
                        tag: 0,
                        selectedTab: $selectedTab
                    )
                    AppNavigatorButton(
                        title: "Discover",
                        iconName: "magnifyingglass",
                        tag: 1,
                        selectedTab: $selectedTab
                    )
//                    AppNavigatorButton(
//                        title: "Cards",
//                        iconName: "rectangle.grid.2x2",
//                        tag: 2,
//                        selectedTab: $selectedTab
//                    )
//                    AppNavigatorButton(
//                        title: "Settings",
//                        iconName: "wrench",
//                        tag: 3,
//                        selectedTab: $selectedTab
//                    )
                }
                .padding(.top)
            }
            .edgesIgnoringSafeArea(.bottom)
        }
    }
    
    func buildView(types: [Any], index: Int) -> AnyView {
        switch types[index].self {
        case is LibraryView.Type: return AnyView(LibraryView())
        case is DiscoverView.Type: return AnyView(DiscoverView())
        case is VocabularyListView.Type: return AnyView(VocabularyListView())
        case is SettingsView.Type: return AnyView(SettingsView())
        default: return AnyView(EmptyView())
        }
    }
}

struct AppNavigator_Previews: PreviewProvider {
    static var previews: some View {
        AppNavigator()
    }
}
