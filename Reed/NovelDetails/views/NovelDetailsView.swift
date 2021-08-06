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
    @StateObject var viewModel: NovelDetailsViewModel
    @EnvironmentObject var definerResults: DefinerResults
    @State private var topExpanded: Bool = true
    @State private var isPushedToReader: Bool = false
    
    init(ncode: String) {
        self._viewModel = StateObject(wrappedValue: NovelDetailsViewModel(ncode: ncode))
    }
    
    var body: some View {
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
                                destination: NavigationLazyView(
                                    ReaderView(
                                        ncode: viewModel.ncode,
                                        novelTitle: viewModel.novelTitle,
                                        isActive: $isPushedToReader
                                    )
                                ),
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
                    ZStack {
                        if viewModel.isNovelSynopsisProcessing {
                            ProgressView()
                                .frame(
                                    width: DefinerConstants.CONTENT_WIDTH,
                                    height: self.viewModel.novelSynopsisHeight
                                )
                        } else {
                            Rectangle()
                                .frame(
                                    width: DefinerConstants.CONTENT_WIDTH,
                                    height: self.viewModel.novelSynopsisHeight
                                )
                        }
                        DefinableText(
                            content: .constant(viewModel.novelSynopsis),
                            tokensRange: [0, 0, viewModel.tokens.endIndex],
                            width: DefinerConstants.CONTENT_WIDTH,
                            height: self.viewModel.novelSynopsisHeight,
                            definerResultHandler: definerResults.updateEntries(newEntries:),
                            getTokenHandler: viewModel.getToken(l:r:x:)
                        )
                    }
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
            .padding(.horizontal)
        }
        .introspectTabBarController { tabBarController in
            tabBarController.tabBar.isHidden = true
        }
        .navigationBarTitle("", displayMode: .inline)
    }
}

struct NovelDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NovelDetailsView(ncode: "n9669bk")
    }
}
