//
//  SearchResults.swift
//  Reed
//
//  Created by Roger Luo on 10/28/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import SwiftUI
import struct SwiftyNarou.NarouRequest
import struct SwiftyNarou.NarouResponseFormat

struct SearchResults: View {
    @ObservedObject var viewModel: DiscoverSearchResultsViewModel
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var btnBack : some View { Button(action: {
        self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "chevron.backward")
                    .imageScale(.large)
                Text("Search")
                    .font(.callout)
                    .fontWeight(.regular)
            }
        }
    }
    
    var body: some View {
        List {
            ForEach(viewModel.searchResults, id: \.self) {
                DiscoverListItem(viewModel: $0)
            }
        }
        .navigationBarTitle(viewModel.keyword, displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: btnBack)
    }
}

struct SearchResults_Previews: PreviewProvider {
    static var previews: some View {
        SearchResults(viewModel: DiscoverSearchResultsViewModel(keyword: "無職転生"))
    }
}

