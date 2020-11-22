//
//  ReaderView.swift
//  Reed
//
//  Created by Roger Luo on 9/9/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import SwiftUI
import SwiftUIPager

struct ReaderView: View {
    @ObservedObject var viewModel: ReaderViewModel
    @State private var entries = [DefinitionDetails]()
    @State private var page: Int = 0

    init(ncode: String) {
        self.viewModel = ReaderViewModel(ncode: ncode)
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                Pager(
                    page: $viewModel.curPage,
                    data: viewModel.pages,
                    id: \.self,
                    content: { text in
                        DefinableTextView(text: text, definerResultHandler: definerResultHandler)
                    }
                )
                .onPageChanged { page in
                    self.viewModel.handlePageFlip(isInit: page == -1)
                }
                .alignment(.start)
                .preferredItemSize(CGSize(
                    width: UIScreen.main.bounds.width,
                    height: UIScreen.main.bounds.height * 0.65
                ))
                Text("\(viewModel.curPage + 1) of \(viewModel.pages.endIndex)")
                Spacer()
                    .frame(height: UIScreen.main.bounds.height * 0.15)
            }
            .padding(.horizontal)
            
            DefinerView(entries: $entries)
        }
        .navigationBarHidden(true)
    }
    
    func definerResultHandler(newEntries: [DefinitionDetails]) {
        self.entries = newEntries
    }
}

struct ReaderView_Previews: PreviewProvider {
    static var previews: some View {
        ReaderView(ncode: "n9669bk")
    }
}
