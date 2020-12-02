//
//  ReaderView.swift
//  Reed
//
//  Created by Roger Luo on 9/9/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import SwiftUI
import Introspect
import SwiftUIPager

struct ReaderView: View {
    @ObservedObject var viewModel: ReaderViewModel
    @State private var entries = [DefinitionDetails]()
    @State private var tabBar: UITabBar?

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
                    content: { page in
                        DefinableTextView(
                            text: .constant(page.content),
                            tokens: page.tokens,
                            definerResultHandler: definerResultHandler,
                            width: viewModel.pagerWidth,
                            height: viewModel.pagerHeight
                        )
                    }
                )
                .onPageChanged { page in
                    self.viewModel.handlePageFlip(isInit: page == -1)
                }
                .alignment(.start)
                
                Text("\(viewModel.curPage + 1) of \(viewModel.pages.endIndex)")
                
                Rectangle()
                    .frame(height: BottomSheetConstants.minHeight)
                    .opacity(0)
            }
            .padding(.horizontal)
            .ignoresSafeArea(edges: .bottom)
            
            DefinerView(entries: $entries)
        }
        .navigationBarHidden(true)
        .introspectTabBarController { tabBarController in
            tabBar = tabBarController.tabBar
            self.tabBar?.isHidden = true
        }
        .onDisappear { self.tabBar?.isHidden = false }
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
