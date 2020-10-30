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
                Text(viewModel.title)
                    .font(.title3)
                    .fontWeight(.medium)
                Spacer()
                
                Text("Synopsis")
                    .font(.headline)
                Text(viewModel.synopsis)
                    .font(.subheadline)
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
