//
//  AppNavigatorInternalTabs.swift
//  Reed
//
//  Created by Roger Luo on 7/29/21.
//  Copyright © 2021 Roger Luo. All rights reserved.
//

import SwiftUI

struct AppNavigatorInternalTabs: View {
    @Binding var selectedTab: Int
    let tabViewTypes: [Any]
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(0 ..< tabViewTypes.endIndex) { i in
                buildView(types: tabViewTypes, index: i)
                    .tag(i)
            }
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

struct AppNavigatorInternalTabs_Previews: PreviewProvider {
    static var previews: some View {
        AppNavigatorInternalTabs(selectedTab: .constant(0), tabViewTypes: [])
    }
}
