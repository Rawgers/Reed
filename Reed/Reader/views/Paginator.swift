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
    @EnvironmentObject private var definerResults: DefinerResults
    @Binding var isNavMenuHidden: Bool
    
    init(
        isNavMenuHidden: Binding<Bool>,
        sectionFetcher: SectionFetcher,
        processedContentPublisher: AnyPublisher<ProcessedContent?, Never>
    ) {
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
                        definerResultHandler: definerResults.updateEntries(newEntries:),
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
    
    func toggleNavHandler() {
        isNavMenuHidden.toggle()
    }
}

//struct ReaderPagerView_Previews: PreviewProvider {
//    static var previews: some View {
//        ReaderPagerView()
//    }
//}
