//
//  TrendingList.swift
//  Reed
//
//  Created by Roger Luo on 10/23/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import SwiftUI

struct TrendingList: View {
    @ObservedObject var viewModel: TrendingListViewModel = TrendingListViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.sections, id: \.self) {
                TrendingListSection(viewModel: $0)
            }
        }
        .listStyle(PlainListStyle())
    }
}

struct TrendingList_Previews: PreviewProvider {
    static var previews: some View {
        TrendingList(viewModel: TrendingListViewModel())
    }
}
