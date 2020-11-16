//
//  NovelDetailsView.swift
//  Reed
//
//  Created by Roger Luo on 10/29/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import SwiftUI

struct NovelDetailsView: View {
    @ObservedObject var viewModel: NovelDetailsViewModel
    
    init(ncode: String) {
        viewModel = NovelDetailsViewModel(ncode: ncode)
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: .zero) {
                Text(viewModel.novelTitle)
                    .font(.title3)
                    .fontWeight(.medium)
                Spacer()
                
                Text("Synopsis")
                    .font(.headline)
                Text(viewModel.novelSynopsis)
                    .font(.subheadline)
                
                Button(action: viewModel.toggleFavorite) {
                    Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                }
                .disabled(viewModel.isLibraryDataLoading)
            }
        }
        .navigationBarTitle("", displayMode: .inline)
    }
}

struct NovelDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NovelDetailsView(ncode: "n9669bk")
    }
}
