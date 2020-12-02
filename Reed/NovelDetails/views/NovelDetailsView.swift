//
//  NovelDetailsView.swift
//  Reed
//
//  Created by Roger Luo on 10/29/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import SwiftUI
import Introspect

struct NovelDetailsView: View {
    @ObservedObject var viewModel: NovelDetailsViewModel
    @State private var topExpanded: Bool = true
    @State private var entries: [DefinitionDetails] = []
    @State private var isPushedToReader: Bool = false
    @State private var tabBar: UITabBar?
    
    init(ncode: String) {
        viewModel = NovelDetailsViewModel(ncode: ncode)
    }
    
    var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    Text(viewModel.novelTitle)
                        .font(.title)
                        .padding(.top, 12)
                        .padding(.bottom, 4)

                    HStack(spacing: .zero) {
                        Text(viewModel.novelAuthor)
                        Text("｜")
                            .foregroundColor(.gray)
                        Text(viewModel.novelSubgenre?.nameJp ?? "")
                    }
                    .padding(.bottom, 16)
                    
                    HStack(spacing: 8) {
                        Button(action: {
                            viewModel.onPushToReader()
                            isPushedToReader = true
                        }) {
                            ZStack {
                                NavigationLink(
                                    destination: NavigationLazyView(ReaderView(ncode: viewModel.ncode)),
                                    isActive: $isPushedToReader
                                ) { EmptyView() }
                                
                                Text("Read")
                                    .frame(width: 72, height: 32)
                                    .foregroundColor(.white)
                                    .background(Color(.systemBlue))
                                    .cornerRadius(4)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                        .disabled(viewModel.isLibraryDataLoading)
                        
                        Button(action: viewModel.toggleFavorite) {
                            Image(systemName: viewModel.isFavorite ? "star.fill" : "star")
                        }
                        .disabled(viewModel.isLibraryDataLoading)
                    }
                    .padding(.bottom, 24)
                    
                    Group {
                        Text("SYNOPSIS")
                            .font(.subheadline).bold()
                            .foregroundColor(Color(.systemGray4))
                            .padding(.bottom, 4)
                        Text(viewModel.novelSynopsis)
                    }
                    .padding(.bottom, 8)
                    
                    FlexView(
                        data: viewModel.novelKeywords,
                        spacing: 8,
                        alignment: .leading,
                        content: { keyword in
                            Text(keyword)
                                .font(.body)
                                .foregroundColor(Color(.systemBlue))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(Color(.systemBlue))
                                )
                        }
                    )
                    .padding(.leading, 1)
                }
            }
            .padding(.horizontal)
            .introspectTabBarController { tabBarController in
                tabBar = tabBarController.tabBar
                self.tabBar?.isHidden = true
            }
            .onDisappear { self.tabBar?.isHidden = false }

            DefinerView(entries: self.$entries)
        }
        .navigationBarTitle("", displayMode: .inline)
    }
}

struct NovelDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NovelDetailsView(ncode: "n9669bk")
    }
}
