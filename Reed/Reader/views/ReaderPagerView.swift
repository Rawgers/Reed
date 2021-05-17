//
//  ReaderPagerView.swift
//  Reed
//
//  Created by Hugo Zhan on 2/3/21.
//  Copyright © 2021 Roger Luo. All rights reserved.
//

import SwiftUI
import SwiftUIPager

struct ReaderPagerView: View {
    @ObservedObject var viewModel: ReaderViewModel
    @Binding var entries: [DefinitionDetails]
    @Binding var isNavMenuHidden: Bool
    
    init(
        entries: Binding<[DefinitionDetails]>,
        isNavMenuHidden: Binding<Bool>,
        ncode: String
    ) {
        self._entries = entries
        self._isNavMenuHidden = isNavMenuHidden
        self.viewModel = ReaderViewModel(ncode: ncode)
    }
    
    var body: some View {
        VStack {
            Pager(
                page: $viewModel.curPage,
                data: viewModel.pages,
                id: \.self,
                content: { page in
                    if viewModel.curPage == -1 {
                        ProgressView()
                            .frame(width: viewModel.pagerWidth, height: viewModel.pagerHeight)
                    } else {
                        DefinableText(
                            content: .constant(page.content),
                            tokensRange: page.tokensRange,
                            width: viewModel.pagerWidth,
                            height: viewModel.pagerHeight,
                            definerResultHandler: definerResultHandler,
                            getTokenHandler: viewModel.getToken,
                            hideNavHandler: hideNavHandler
                        )
                    }
                }
            )
            .allowsDragging(viewModel.curPage != -1)
            .onPageChanged { page in
                self.viewModel.handlePageFlip(isInit: page == -1)
            }
            .alignment(.start)
            Text(viewModel.getPageNumberDisplay())
        }
    }
    
    func definerResultHandler(newEntries: [DefinitionDetails]) {
        self.entries = newEntries
    }
    
    func hideNavHandler() {
        isNavMenuHidden.toggle()
    }
}

//struct ReaderPagerView_Previews: PreviewProvider {
//    static var previews: some View {
//        ReaderPagerView()
//    }
//}
