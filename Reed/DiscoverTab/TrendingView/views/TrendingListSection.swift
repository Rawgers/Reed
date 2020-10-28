//
//  TrendingListSection.swift
//  Reed
//
//  Created by Roger Luo on 10/23/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import SwiftUI

struct TrendingListSection: View {
    @ObservedObject var viewModel: TrendingListSectionViewModel
    
    var body: some View {
        Section(header: Text(viewModel.header)) {
            ForEach(viewModel.items, id: \.self) {
                DiscoverListItem(viewModel: $0)
            }
        }
    }
}

struct TrendingListSection_Previews: PreviewProvider {
    static var previews: some View {
        TrendingListSection(
            viewModel: TrendingListSectionViewModel(category: .recent)
        )
    }
}
