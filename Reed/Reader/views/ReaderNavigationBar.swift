//
//  ReaderNavigationBar.swift
//  Reed
//
//  Created by Hugo Zhan on 2/3/21.
//  Copyright © 2021 Roger Luo. All rights reserved.
//

import SwiftUI

struct ReaderNavigationBar: View {
    let sectionFetcher: SectionFetcher
    var novelTitle: String
    var sectionNcode: Binding<String>
    @Binding var isNavMenuHidden: Bool
    @State var isSectionNavigationPresented: Bool = false
    @Environment(\.presentationMode) var presentationMode
    
    init(
        sectionFetcher: SectionFetcher,
        novelTitle: String,
        sectionNcode: Binding<String>,
        isNavMenuHidden: Binding<Bool>
    ) {
        self.sectionFetcher = sectionFetcher
        self.novelTitle = novelTitle
        self.sectionNcode = sectionNcode
        self._isNavMenuHidden = isNavMenuHidden
    }
    
    private var titleView: some View {
        Text(novelTitle)
            .frame(height: 48)
            .padding(.horizontal)
    }
    
    private var menuView: some View {
        HStack {
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.backward")
            }
            Button(action: { self.isSectionNavigationPresented.toggle() }) {
                Image(systemName: "list.dash")
                    .imageScale(.large)
            }
            Spacer()
        }
        .frame(width: UIScreen.main.bounds.width, height: 48)
        .padding(.leading)
        .fullScreenCover(
            isPresented: $isSectionNavigationPresented,
            content: {
                SectionNavigationView(
                    sectionNcode: sectionNcode,
                    handleFetchSection: sectionFetcher.fetchSection
                )
            }
        )
    }
    
    var body: some View {
        if isNavMenuHidden {
            titleView
        } else {
            menuView
        }
    }
}

//struct ReaderNavigationBar_Previews: PreviewProvider {
//    static var previews: some View {
//        ReaderNavigationBar(navBarHidden: true)
//    }
//}
