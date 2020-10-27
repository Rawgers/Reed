//
//  DiscoverView.swift
//  Reed
//
//  Created by Roger Luo on 9/9/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import SwiftUI

struct DiscoverView: View {
    let searchBar = SearchBar(onClickSearch: nil)
    
    var body: some View {
        NavigationView {
            TrendingList(viewModel: TrendingListViewModel())
                .navigationBarTitle("Discover")
                .navigationBarSearchController(
                    from: self.searchBar,
                    hidesWhenScrolling: false
                )
        }
    }
}

struct DiscoverView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverView()
    }
}
