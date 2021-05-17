//
//  ReaderPagerView.swift
//  Reed
//
//  Created by Hugo Zhan on 2/3/21.
//  Copyright © 2021 Roger Luo. All rights reserved.
//

import Combine
import SwiftUI
import SwiftUIPager

struct ReaderPagerView: View {
    @ObservedObject var viewModel: ReaderPaginatorViewModel
    @Binding var entries: [DefinitionDetails]
    @Binding var isNavMenuHidden: Bool
    
    init(
        entries: Binding<[DefinitionDetails]>,
        isNavMenuHidden: Binding<Bool>,
        sectionFetcher: SectionFetcher,
        paginatorWidth: CGFloat,
        paginatorHeight: CGFloat,
        processedContentPublisher: AnyPublisher<ProcessedContent?, Never>
    ) {
        self._entries = entries
        self._isNavMenuHidden = isNavMenuHidden
        self.viewModel = ReaderPaginatorViewModel(
            sectionFetcher: sectionFetcher,
            paginatorWidth: paginatorWidth,
            paginatorHeight: paginatorHeight,
            processedContentPublisher: processedContentPublisher
        )
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
                            .frame(width: viewModel.paginatorWidth, height: viewModel.paginatorHeight)
                    } else {
                        DefinableText(
                            content: .constant(page.content),
                            tokensRange: page.tokensRange,
                            width: viewModel.paginatorWidth,
                            height: viewModel.paginatorHeight,
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
