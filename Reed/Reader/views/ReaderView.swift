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
    @State private var navBar: UINavigationBar?
    @State private var isSectionNavigationPresented: Bool = false
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    init(ncode: String) {
        self.viewModel = ReaderViewModel(ncode: ncode)
    }
    
    var sectionNavigationButton: some View {
        Button(action: { self.isSectionNavigationPresented.toggle() }) {
            HStack {
                Image(systemName: "list.dash")
                    .imageScale(.large)
            }
        }
        .fullScreenCover(
            isPresented: $isSectionNavigationPresented,
            content: {
                SectionNavigationView(
                    sectionNcode: viewModel.historyEntry!.sectionNcode
                )
            }
        )
    }
    
    var navigationBarButtons: some View {
        HStack {
            NavigationBackChevron(
                label: "",
                handleDismiss: { self.presentationMode.wrappedValue.dismiss() }
            )
            sectionNavigationButton
        }
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                Pager(
                    page: $viewModel.curPage,
                    data: viewModel.pages,
                    id: \.self,
                    content: { page in
                        if viewModel.curPage == -1
                            || (viewModel.section?.nextNcode != nil && viewModel.curPage == viewModel.pages.endIndex - 1)
                            || (viewModel.section?.prevNcode != nil && viewModel.curPage == 0) {
                            ProgressView()
                        } else {
                            DefinableTextView(
                                text: .constant(page.content),
                                tokens: page.tokens,
                                definerResultHandler: definerResultHandler,
                                hideNavHandler: hideNavHandler,
                                width: viewModel.pagerWidth,
                                height: viewModel.pagerHeight
                            )
                        }
                    }
                )
                .allowsDragging((viewModel.section?.prevNcode == nil || viewModel.curPage != 0)
                    && (viewModel.section?.nextNcode == nil || viewModel.curPage != viewModel.pages.endIndex - 1))
                .onPageChanged { page in
                    self.viewModel.handlePageFlip(isInit: page == -1)
                }
                .alignment(.start)
                
                Text(viewModel.getPageNumberDisplay())
                
                Rectangle()
                    .frame(height: BottomSheetConstants.minHeight)
                    .opacity(0)
            }
            .padding(.horizontal)
            .ignoresSafeArea(edges: .bottom)
        
            DefinerView(entries: $entries)
        }
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: navigationBarButtons)
        .introspectNavigationController { navigationController in
            self.navBar = navigationController.navigationBar
            self.navBar?.isHidden = true
            self.navBar?.backgroundColor = .systemBackground
        }
        .introspectTabBarController { tabBarController in
            tabBarController.tabBar.isHidden = true
        }
        .onTapGesture(count: 2) {
            hideNavHandler()
        }
    }
    
    func definerResultHandler(newEntries: [DefinitionDetails]) {
        self.entries = newEntries
    }
    
    func hideNavHandler() {
        navBar?.isHidden = !(navBar?.isHidden ?? true)
    }
}

struct ReaderView_Previews: PreviewProvider {
    static var previews: some View {
        ReaderView(ncode: "n9669bk")
    }
}
