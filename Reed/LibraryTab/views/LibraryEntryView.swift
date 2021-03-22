//
//  LibraryViewController.swift
//  Reed
//
//  Created by Roger Luo on 9/9/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import SwiftUI

struct LibraryEntryView: View {
    @State var isPushedToReader = false
    var viewModel: LibraryEntryViewModel
    
    init(entryData: HistoryEntry) {
        viewModel = LibraryEntryViewModel(entryData: entryData)
    }

    var body: some View {
        ZStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text(viewModel.title)
                    .font(.headline)
                    .lineLimit(2)
                    .truncationMode(.tail)
                Text(viewModel.author)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
            NavigationLink(
                destination: NavigationLazyView(ReaderView(ncode: viewModel.ncode, title: viewModel.title, isActive: $isPushedToReader)),
                isActive: $isPushedToReader
            ) { EmptyView() }
        }
    }
}

struct LibraryEntryViewController_Previews: PreviewProvider {
    
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let entryData = HistoryEntry(context: context)
        entryData.ncode = "n9669bk"
        entryData.title = "無職転生　- 異世界行ったら本気だす -"
        entryData.author = "理不尽な孫の手"
        
        return LibraryEntryView(entryData: entryData)
    }
}
