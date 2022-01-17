//
//  ContentView.swift
//  Reed
//
//  Created by Roger Luo on 9/9/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import SwiftUI

struct LibraryView: View {
    @StateObject private var definerResults = DefinerResults()
    @StateObject private var viewModel: LibraryViewModel = LibraryViewModel()
    let switchToDiscover: () -> Void

    var body: some View {
        NavigationView {
            ScrollView {
                NovelList(
                    rowData: $viewModel.libraryEntryData,
                    definerResultHandler: definerResults.updateEntries(entries:),
                    updateRows: {},
                    pushedViewType: .Reader
                )
            }
            .onAppear {
                viewModel.fetchEntries() { willSwitchToDiscover in
                    if willSwitchToDiscover {
                        switchToDiscover()
                    }
                }
            }
            .navigationBarTitle("Library")
            .addDefinerAndAppNavigator(entries: $definerResults.entries)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

//struct LibraryView_Previews: PreviewProvider {
//    static var previews: some View {
//        let viewModel = LibraryViewModel()
//        return LibraryView(viewModel: viewModel)
//    }
//}
