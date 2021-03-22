//
//  ReaderNavigationBar.swift
//  Reed
//
//  Created by Hugo Zhan on 2/3/21.
//  Copyright © 2021 Roger Luo. All rights reserved.
//

import SwiftUI

struct ReaderNavigationBar: View {
    var title: String
    @Binding var isNavMenuHidden: Bool
    @Binding var isActive: Bool
    
    private var titleView: some View {
        Text(title)
            .frame(width: UIScreen.main.bounds.width, height: 48)
            .padding(.horizontal)
    }
    
    private var menuView: some View {
        HStack {
            Button(action: {
                isActive.toggle()
            }) {
                Image(systemName: "chevron.backward")
            }
            Button(action: {
                
            }) {
                Image(systemName: "list.dash")
            }
            Spacer()
        }
        .frame(width: UIScreen.main.bounds.width, height: 48)
        .padding(.leading)
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
