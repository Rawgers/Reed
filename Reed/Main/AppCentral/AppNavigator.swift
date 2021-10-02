//
//  AppNavigator.swift
//  Reed
//
//  Created by Roger Luo on 10/2/21.
//  Copyright © 2021 Roger Luo. All rights reserved.
//

import SwiftUI

struct AppNavigator: View {
    @Binding var selectedTab: Int
    
    var body: some View {
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
//            AppNavigatorTab(
//                title: "Cards",
//                iconName: "rectangle.grid.2x2",
//                tag: 2,
//                selectedTab: $selectedTab
//            )
//            AppNavigatorTab(
//                title: "Settings",
//                iconName: "wrench",
//                tag: 3,
//                selectedTab: $selectedTab
//            )
        }
        .padding(.top)
    }
}

struct AppNavigator_Previews: PreviewProvider {
    static var previews: some View {
        AppNavigator(selectedTab: .constant(0))
    }
}
