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
    @ObservedObject var viewModel: ReaderViewModel
    
    @State private var entries = [DefinitionDetails]()
    @State private var isNavMenuHidden = true
    let ncode: String
    let novelTitle: String
    @Binding var isActive: Bool
    
    init(ncode: String, novelTitle: String, isActive: Binding<Bool>) {
        self.ncode = ncode
        self.novelTitle = novelTitle
        self._isActive = isActive
        
        self.viewModel = ReaderViewModel(ncode: ncode)
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
                VStack(alignment: .center) {
                    Paginator(
                        entries: $entries,
                        isNavMenuHidden: $isNavMenuHidden,
                        sectionFetcher: viewModel.sectionFetcher,
                        paginatorWidth: viewModel.paginatorWidth,
                        paginatorHeight: viewModel.paginatorHeight,
                        processedContentPublisher: viewModel.$processedContent.eraseToAnyPublisher()
                    )
                    
                    Rectangle()
                        .frame(height: BottomSheetConstants.minHeight)
                        .opacity(0)
                }
                .padding(.horizontal)
                .ignoresSafeArea(edges: .bottom)
                .background(Color(.systemBackground))
                .onTapGesture(count: 2) {
                    isNavMenuHidden.toggle()
                }
                .navigationBarHidden(true)
                
                if viewModel.isLoading {
                    ProgressView()
                        .frame(
                            width: viewModel.paginatorWidth,
                            height: viewModel.paginatorHeight
                        )
                }
                
                DefinerView(entries: $entries)
            }
            .navigationBarTitle("", displayMode: .inline)
            .introspectTabBarController { tabBarController in
                tabBarController.tabBar.isHidden = true
            }
        }
    }
}

//struct ReaderView_Previews: PreviewProvider {
//    static var previews: some View {
//        ReaderView(ncode: "n9669bk")
//    }
//}
