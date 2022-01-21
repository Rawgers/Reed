//
//  AppNavigator.swift
//  Reed
//
//  Created by Roger Luo on 7/21/21.
//  Copyright © 2021 Roger Luo. All rights reserved.
//

import SwiftUI

enum BottomSheetDisplayType {
    case navigation
    case definer
}

class AppState: ObservableObject {
    @Published var selectedTab: Int = 0
    
    func switchToDiscover() {
        selectedTab = 1
    }
}

struct AppCentral: View {
    @StateObject private var appState = AppState()
    
    var body: some View {
        TabView(selection: $appState.selectedTab) {
            LibraryView(switchToDiscover: appState.switchToDiscover)
                .tag(0)
                .introspectTabBarController { tabBarController in
                    tabBarController.tabBar.isHidden = true
                }
            
            DiscoverView()
                .tag(1)
                .introspectTabBarController { tabBarController in
                    tabBarController.tabBar.isHidden = true
                }
            
//            VocabularyListView()
//              .tag(2)
//
            SettingsView()
              .tag(3)
        }
        .environmentObject(appState)
    }
}


struct AppCentral_Previews: PreviewProvider {
    static var previews: some View {
        AppCentral()
    }
}
