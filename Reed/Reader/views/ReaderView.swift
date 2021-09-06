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
    
    @State private var isNavMenuHidden = true
    let ncode: String
    let novelTitle: String
    @Binding var isActive: Bool
    
    init(ncode: String, novelTitle: String, isActive: Binding<Bool>) {
        self.ncode = ncode
        self.novelTitle = novelTitle
        self._isActive = isActive
        
        self._viewModel = StateObject(wrappedValue: ReaderViewModel(ncode: ncode))
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
                    switchSectionHandler: viewModel.handleSwitchSection
                )

                if viewModel.isLoading {
                    ProgressView()
                }
            }
            .padding(.horizontal, 16)
        }
        .navigationBarHidden(true)
    }
}

//struct ReaderView_Previews: PreviewProvider {
//    static var previews: some View {
//        ReaderView(ncode: "n9669bk")
//    }
//}
