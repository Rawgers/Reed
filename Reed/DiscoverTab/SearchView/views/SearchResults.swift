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
    let definerResultHandler: ([DefinitionDetails]) -> Void
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ScrollView {
            LazyVStack {
                Divider()
                ForEach(viewModel.searchResults, id: \.self) { result in
                    DiscoverListItem(
                        viewModel: result,
                        definerResultHandler: definerResultHandler
                    ).onAppear {
                        if self.viewModel.searchResults.last == result {
                            self.viewModel.updateSearchResults()
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
        .navigationBarTitle(viewModel.keyword, displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: NavigationBackChevron(
            label: "Search",
            handleDismiss: { self.presentationMode.wrappedValue.dismiss() }
        ))
    }
}

struct SearchResults_Previews: PreviewProvider {
    static var previews: some View {
        SearchResults(
            viewModel: DiscoverSearchResultsViewModel(keyword: "無職転生"),
            definerResultHandler: { _ in }
        )
    }
}
