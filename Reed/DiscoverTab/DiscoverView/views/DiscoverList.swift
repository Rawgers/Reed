//
//  DiscoverList.swift
//  Reed
//
//  Created by Roger Luo on 10/23/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import SwiftUI

struct DiscoverList: View {
    @Binding var category: DiscoverListCategory
    @ObservedObject var viewModel: DiscoverListViewModel
    
    init(category: Binding<DiscoverListCategory>) {
        self._category = category
        viewModel = DiscoverListViewModel(category: category.wrappedValue)
    }
    
    var body: some View {
        LazyVStack(alignment: .leading) {
            Divider()
            ForEach(viewModel.items, id: \.self) {
                DiscoverListItem(viewModel: $0)
            }
        }
        .padding(.horizontal)
    }
}

struct DiscoverList_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverList(
            category: .constant(.recent)
        )
    }
}
