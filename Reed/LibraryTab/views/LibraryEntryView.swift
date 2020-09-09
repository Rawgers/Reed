//
//  LibraryViewController.swift
//  Reed
//
//  Created by Roger Luo on 9/9/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import SwiftUI

struct LibraryEntryView: View {
    var entry: LibraryEntry

    var body: some View {
        VStack(alignment: .leading) {
            Text(entry.title ?? "unknown")
                .font(.headline)
            Text(entry.author ?? "unknown")
                .font(.caption)
        }
    }
}

struct LibraryViewController_Previews: PreviewProvider {
    
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let entry = LibraryEntry(context: context)
        entry.title = "無職転生　- 異世界行ったら本気だす -"
        entry.author = "理不尽な孫の手"
        
        return LibraryEntryView(entry: entry).environment(\.managedObjectContext, context)
    }
}
