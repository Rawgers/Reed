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
                LazyVStack {
                    Divider()
                    ForEach(viewModel.libraryEntryData, id: \.self) { data in
                        LibraryEntryView(
                            lastSelectedDefinableTextView: $lastSelectedDefinableTextView,
                            definerResultHandler: definerResults.updateEntries(entries:),
                            data: data
                        )
                    }
                }
                .padding(.horizontal)
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
