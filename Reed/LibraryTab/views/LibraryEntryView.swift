//
//  LibraryViewController.swift
//  Reed
//
//  Created by Roger Luo on 9/9/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import SwiftUI

struct LibraryEntryView: View {
    var entry: LibraryEntryViewModel

    var body: some View {
        VStack(alignment: .leading) {
            Text(entry.title)
                .font(.headline)
                .lineLimit(1)
                .truncationMode(.tail)
            Text(entry.author)
                .font(.caption)
                .foregroundColor(.gray)
                .lineLimit(1)
                .truncationMode(.tail)
        }
    }
}

struct LibraryViewController_Previews: PreviewProvider {
    
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let entryData = LibraryEntry(context: context)
        entryData.title = "無職転生　- 異世界行ったら本気だす -"
        entryData.author = "理不尽な孫の手"
        let entry = LibraryEntryViewModel(entryData: entryData)
        
        return LibraryEntryView(entry: entry).environment(\.managedObjectContext, context)
    }
}
