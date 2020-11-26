//
//  ContentView.swift
//  Reed
//
//  Created by Roger Luo on 9/9/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import SwiftUI

struct LibraryView: View {
    @ObservedObject var viewModel: LibraryViewModel = LibraryViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.novels, id: \.self) {
                    LibraryEntryView(entryData: $0)
                }
            }
            .navigationBarTitle("Library")
        }
    }
}

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = LibraryViewModel()
        return LibraryView(viewModel: viewModel)
    }
}
