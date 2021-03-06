//
//  ReaderPagerView.swift
//  Reed
//
//  Created by Hugo Zhan on 2/3/21.
//  Copyright © 2021 Roger Luo. All rights reserved.
//

import Combine
import SwiftUI

struct Paginator: View {
    @StateObject var viewModel: PaginatorViewModel
    @Binding var entries: [DefinitionDetails]
    @Binding var isNavMenuHidden: Bool
    
    init(
        entries: Binding<[DefinitionDetails]>,
        isNavMenuHidden: Binding<Bool>,
        sectionFetcher: SectionFetcher,
        processedContentPublisher: AnyPublisher<ProcessedContent?, Never>
    ) {
        self._entries = entries
        self._isNavMenuHidden = isNavMenuHidden
        self._viewModel = StateObject(wrappedValue: PaginatorViewModel(
            sectionFetcher: sectionFetcher,
            processedContentPublisher: processedContentPublisher
        ))
    }
    
    var body: some View {
        VStack {
            TabView(selection: $viewModel.curPage) {
                ForEach(viewModel.pages.indices, id: \.self) { i in
                    let page = viewModel.pages[i]
                    DefinableText(
                        content: .constant(page.content),
                        tokensRange: page.tokensRange,
                        width: DefinerConstants.CONTENT_WIDTH,
                        height: DefinerConstants.CONTENT_HEIGHT,
                        definerResultHandler: definerResultHandler,
                        getTokenHandler: viewModel.getToken,
                        toggleNavHandler: toggleNavHandler
                    )
                    .onAppear {
                        viewModel.handlePageFlip()
                    }
                }
            }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))

            Text(viewModel.getPageNumberDisplay())
        }
    }
    
    func definerResultHandler(newEntries: [DefinitionDetails]) {
        self.entries = newEntries
    }
    
    func toggleNavHandler() {
        isNavMenuHidden.toggle()
    }
}

//struct ReaderPagerView_Previews: PreviewProvider {
//    static var previews: some View {
//        ReaderPagerView()
//    }
//}
