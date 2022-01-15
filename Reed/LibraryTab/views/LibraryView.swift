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
    @State private var lastSelectedDefinableTextView: DefinableTextView?

    var body: some View {
        NavigationView {
            ScrollView {
                NovelList(
                    rowData: $viewModel.libraryEntryData,
                    lastSelectedDefinableTextView: $lastSelectedDefinableTextView,
                    definerResultHandler: definerResults.updateEntries(entries:),
                    updateRows: {},
                    pushedViewType: .Reader
                )
            }
            .onAppear {
                viewModel.fetchEntries()
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
