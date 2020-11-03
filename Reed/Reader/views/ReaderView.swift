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
    @ObservedObject var definitionModalViewModel: DefinitionModalViewModel = DefinitionModalViewModel()
    @State var page: Int = 0
    @State private var currentPosition: CGSize = .zero
    @State private var newPosition: CGSize = .zero

    init(ncode: String) {
        self.viewModel = ReaderViewModel(ncode: ncode)
    }
    
    var body: some View {
        VStack(alignment: .center) {
            Pager(
                page: $page,
                data: viewModel.items,
                id: \.self,
                content: { text in
                    VStack(alignment: .center, spacing: /*@START_MENU_TOKEN@*/nil/*@END_MENU_TOKEN@*/) {
                        TextView(text: text, defineSelection: definitionModalViewModel.generateContent)
                    }
            }).alignment(.start).preferredItemSize(CGSize(
                width: UIScreen.main.bounds.width,
                height: UIScreen.main.bounds.height * 0.6
            ))
            
            DefinitionModal(viewModel: definitionModalViewModel)
                .frame(
                    width: UIScreen.main.bounds.width * 0.8,
                    height: UIScreen.main.bounds.height * 0.2
                ).cornerRadius(20)
                .offset(
                    x: self.currentPosition.width,
                    y: self.currentPosition.height
                ).gesture(DragGesture().onChanged { value in
                    self.currentPosition = CGSize(
                        width: self.newPosition.width,
                        height: value.translation.height + self.newPosition.height
                    )
                }.onEnded { value in
                    self.currentPosition = CGSize(
                        width: self.newPosition.width,
                        height: value.translation.height + self.newPosition.height
                    )
                    self.newPosition = self.currentPosition
                })
            
            Text("\(page + 1)")
        }
        .navigationBarHidden(true)
     }
}



struct ReaderView_Previews: PreviewProvider {
    static var previews: some View {
        ReaderView(ncode: "n9669bk")
    }
}
