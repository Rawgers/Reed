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
    @State private var selectedRange: NSRange?
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
                        content: .constant(page.content), // revisit this
                        selectedRange: $selectedRange,
                        tokensRange: page.tokensRange,
                        width: DefinerConstants.CONTENT_WIDTH,
                        height: DefinerConstants.CONTENT_HEIGHT,
                        definerResultHandler: definerResultHandler,
                        getTokenHandler: viewModel.getToken,
                        hideNavHandler: hideNavHandler
                    )
                    .onAppear {
                        viewModel.handlePageFlip(p: i)
                        clearSelectedRange(content: viewModel.pages[i].content)
                    }
                }
            }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))

            Text(viewModel.getPageNumberDisplay())
        }
    }
    
    func definerResultHandler(newEntries: [DefinitionDetails]) {
        self.entries = newEntries
    }
    
    func hideNavHandler() {
        isNavMenuHidden.toggle()
    }
    
    func clearSelectedRange(content: NSMutableAttributedString) {
        guard let selectedRange = self.selectedRange else { return }
        content.addAttribute(
            NSAttributedString.Key.backgroundColor,
            value: UIColor.clear,
            range: selectedRange
        )
        self.selectedRange = nil
    }
}

//struct ReaderPagerView_Previews: PreviewProvider {
//    static var previews: some View {
//        ReaderPagerView()
//    }
//}
