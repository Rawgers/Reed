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
    @State private var entries = [DefinitionDetails]()
    @State private var isNavMenuHidden = true
    let ncode: String
    let title: String
    @Binding var isActive: Bool
    
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
                    sectionNcode: viewModel.sectionNcode,
                    handleFetchSection: viewModel.fetchNextSection
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
        VStack(spacing: 0) {
            ReaderNavigationBar(title: title, isNavMenuHidden: $isNavMenuHidden, isActive: $isActive)
            ZStack {
                VStack(alignment: .center) {
                    ReaderPagerView(entries: $entries, isNavMenuHidden: $isNavMenuHidden, ncode: ncode)
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
