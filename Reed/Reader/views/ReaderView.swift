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
    @Binding var isActive: Bool
    let ncode: String
    let novelTitle: String
    
    init(ncode: String, novelTitle: String, isActive: Binding<Bool>) {
        self._viewModel = StateObject(wrappedValue: ReaderViewModel(ncode: ncode))
        self._isActive = isActive
        self.ncode = ncode
        self.novelTitle = novelTitle
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ReaderNavigationBar(
                sectionFetcher: viewModel.sectionFetcher,
                novelTitle: novelTitle,
                sectionNcode: $viewModel.sectionNcode,
                isNavMenuHidden: $isNavMenuHidden,
                isActive: $isActive
            )

            ZStack {
                WKText(
                    processedContentPublisher: viewModel.$processedContent.eraseToAnyPublisher(),
                    definerResultHandler: definerResults.updateEntries,
                    switchSectionHandler: viewModel.handleSwitchSection
                )

                if viewModel.isLoading {
                    ProgressView()
                }
            }
            .padding(.horizontal)
            .addDefinerAndAppNavigator(entries: $definerResults.entries)
        }
        .navigationBarHidden(true)
    }
}

//struct ReaderView_Previews: PreviewProvider {
//    static var previews: some View {
//        ReaderView(ncode: "n9669bk")
//    }
//}
