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
    @StateObject private var definerResults: DefinerResults = DefinerResults()
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
                        .foregroundColor(.secondary)
                    Text("｜")
                        .foregroundColor(.secondary)
                    Text(viewModel.novelSubgenre?.nameJp ?? "")
                        .foregroundColor(.secondary)
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
                        Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                    }
                    .disabled(viewModel.isLibraryDataLoading)
                }
                .padding(.bottom, 24)

                Group {
                    Text("SYNOPSIS")
                        .font(.subheadline).bold()
                        .foregroundColor(.secondary)
                        .padding(.bottom, 4)
                    ZStack {
                        Rectangle()
                            .frame(
                                width: DefinerConstants.CONTENT_WIDTH,
                                height: viewModel.isSynopsisExpanded
                                    ? viewModel.novelSynopsisHeight
                                    : viewModel.COLLAPSED_SYNOPSIS_HEIGHT
                            )
                        WKText(
                            processedContentPublisher: viewModel.$novelSynopsis.eraseToAnyPublisher(),
                            isScrollEnabled: false,
                            definerResultHandler: definerResults.updateEntries,
                            updateSynopsisHeightHandler: viewModel.saveNovelSynopsisHeight
                        )
                        if !viewModel.isSynopsisExpanded {
                            VStack {
                                Spacer()
                                LinearGradient(
                                    colors: [.white.opacity(0), .white.opacity(0.9)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                                    .frame(height: 16)
                            }
                        }
                    }
                }

                if viewModel.novelSynopsisHeight
                    > viewModel.COLLAPSED_SYNOPSIS_HEIGHT {
                    HStack {
                        Spacer()
                        Button(action: {
                            viewModel.isSynopsisExpanded.toggle()
                        }) {
                            Text(viewModel.isSynopsisExpanded ? "less" : "more")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .padding(.trailing)
                        }
                    }
                    .padding(.bottom, 16)
                }
                
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
            .padding(.bottom, DefinerConstants.BOTTOM_SHEET_SHADOW_RADIUS)
        }
        .navigationBarTitle("", displayMode: .inline)
        .addDefinerAndAppNavigator(entries: $definerResults.entries)
    }
}

struct NovelDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NovelDetailsView(ncode: "n9669bk")
    }
}
