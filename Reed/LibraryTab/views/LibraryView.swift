//
//  ContentView.swift
//  Reed
//
//  Created by Roger Luo on 9/9/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import SwiftUI

struct LibraryView: View {
    @FetchRequest(entity: LibraryEntry.entity(), sortDescriptors: [])
    var libraryEntries: FetchedResults<LibraryEntry>
    
    var body: some View {
        NavigationView {
            List {
                ForEach(libraryEntries, id: \.self) { entry in
                    LibraryEntryView(entry: entry)
                }
            }
            .navigationBarTitle("Library", displayMode: .inline)
        }
    }
}

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return LibraryView().environment(\.managedObjectContext, context)
    }
}
