//
//  ContentView.swift
//  Reed
//
//  Created by Roger Luo on 9/9/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import SwiftUI

struct LibraryView: View {
    @ObservedObject var viewModel: LibraryViewModel
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.libraryEntries, id: \.self) { entry in
                    LibraryEntryView(entry: entry)
                }
            }
            .navigationBarTitle("Library", displayMode: .inline)
        }
    }
}

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = LibraryViewModel()
        return LibraryView(viewModel: viewModel)
    }
}
