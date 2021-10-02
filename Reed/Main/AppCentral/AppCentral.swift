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
}

struct AppCentral: View {
    @StateObject private var appState = AppState()
    
    var body: some View {
        TabView(selection: $appState.selectedTab) {
            LibraryView()
                .tag(0)
            
            DiscoverView()
                .tag(1)
            
//            VocabularyListView()
//              .tag(2)
//
//            SettingsView()
//              .tag(3)
        }
        .ignoresSafeArea(edges: .bottom)
        .introspectTabBarController { tabBarController in
            tabBarController.tabBar.isHidden = true
        }
        .environmentObject(appState)
    }
}


struct AppCentral_Previews: PreviewProvider {
    static var previews: some View {
        AppCentral()
    }
}
