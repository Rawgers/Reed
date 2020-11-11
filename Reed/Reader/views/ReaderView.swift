//
//  ReaderView.swift
//  Reed
//
//  Created by Roger Luo on 9/9/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import SwiftUI
import SwiftUIPager


struct ReaderView: View {
    @ObservedObject var viewModel: ReaderViewModel
    @ObservedObject var definitionViewModel: DefinitionViewModel = DefinitionViewModel()
    @State var page: Int = 0
    @State private var currentPosition: CGSize = .zero
    @State private var newPosition: CGSize = .zero
    @State private var isBottomSheetExpanded = false

    init(ncode: String) {
        self.viewModel = ReaderViewModel(ncode: ncode)
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                Pager(
                    page: $page,
                    data: viewModel.items,
                    id: \.self,
                    content: { text in
                        VStack(alignment: .center, spacing: /*@START_MENU_TOKEN@*/nil/*@END_MENU_TOKEN@*/) {
                            TextView(text: text, defineSelection: definitionViewModel.generateContent)
                        }
                }).alignment(.start).preferredItemSize(CGSize(
                    width: UIScreen.main.bounds.width,
                    height: UIScreen.main.bounds.height * 0.6
                ))
                Text("\(page + 1) of \(viewModel.items.count)")
                Spacer()
                    .frame(height: UIScreen.main.bounds.height * 0.15)
            }
            GeometryReader { geometry in
                BottomSheetView (
                    isOpen: self.$isBottomSheetExpanded,
                    maxHeight: geometry.size.height * 0.4) {
                        DefinitionView(viewModel: definitionViewModel)
                    }
            }
            .edgesIgnoringSafeArea(.all)
        }
        .navigationBarHidden(true)
     }
}



struct ReaderView_Previews: PreviewProvider {
    static var previews: some View {
        ReaderView(ncode: "n9669bk")
    }
}
