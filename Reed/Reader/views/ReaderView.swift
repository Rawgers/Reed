//
//  ReaderView.swift
//  Reed
//
//  Created by Roger Luo on 9/9/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import SwiftUI
import Introspect

struct ReaderView: View {
    @StateObject var viewModel: ReaderViewModel
    @StateObject var definerResults: DefinerResults = DefinerResults()
    @State private var isNavMenuHidden = true
    let ncode: String
    let novelTitle: String
    
    init(ncode: String, novelTitle: String) {
        self._viewModel = StateObject(wrappedValue: ReaderViewModel(ncode: ncode))
        self.ncode = ncode
        self.novelTitle = novelTitle
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ReaderNavigationBar(
                sectionFetcher: viewModel.sectionFetcher,
                novelTitle: novelTitle,
                sectionNcode: $viewModel.sectionNcode,
                isNavMenuHidden: $isNavMenuHidden
            )

            ZStack {
                WKText(
                    processedContentPublisher: viewModel.$processedContent.eraseToAnyPublisher(),
                    viewType: .body,
                    isScrollEnabled: true,
                    definerResultHandler: definerResults.updateEntries,
                    switchSectionHandler: viewModel.handleSwitchSection,
                    readerViewNavigationMenuToggleHandler: toggleReaderViewNavigationMenu
                )

                if viewModel.isLoading {
                    RoundedSquareProgressView()
                }
            }
            .padding(.horizontal)
            .addDefinerAndAppNavigator(entries: $definerResults.entries)
        }
        .navigationBarHidden(true)
    }
    
    func toggleReaderViewNavigationMenu() {
        self.isNavMenuHidden.toggle()
    }
}

//struct ReaderView_Previews: PreviewProvider {
//    static var previews: some View {
//        ReaderView(ncode: "n9669bk")
//    }
//}
