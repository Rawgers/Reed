//
//  AppView.swift
//  Reed
//
//  Created by Roger Luo on 9/9/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import SwiftUI

struct AppView: View {
    
    var body: some View {
        TabView {
            LibraryView()
                .tabItem {
                    Image(systemName: "books.vertical")
                    Text("Library")
                }

            DiscoverView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Discover")
                }

//            VocabularyListsView()
//                .tabItem {
//                    Image(systemName: "rectangle.grid.2x2")
//                    Text("Cards")
//                }
//
//            SettingsView()
//                .tabItem {
//                    Image(systemName: "wrench")
//                    Text("Settings")
//                }
        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        return AppView()
    }
}
