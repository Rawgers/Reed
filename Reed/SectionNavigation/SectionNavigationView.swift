//
//  SectionNavigationView.swift
//  Reed
//
//  Created by Roger Luo on 1/16/21.
//  Copyright © 2021 Roger Luo. All rights reserved.
//

import SwiftUI
import SwiftyNarou

struct SectionNavigationView: View {
    @ObservedObject var viewModel: SectionNavigationViewModel
    @Environment(\.presentationMode) var presentationMode
    @Binding var sectionNcode: String
    
    init(
        sectionNcode: Binding<String>,
        handleFetchSection: @escaping (String) -> Void
    ) {
        let novelNcode = sectionNcode
            .wrappedValue.lowercased().components(separatedBy: "/")[0]
        viewModel = SectionNavigationViewModel(
            novelNcode: novelNcode,
            handleFetchSection: handleFetchSection
        )
        self._sectionNcode = sectionNcode
    }
    
    var dismissButton: some View {
        Button("Done") {
            self.presentationMode.wrappedValue.dismiss()
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                ScrollViewReader { scrollOffset in
                    VStack(alignment: .leading, spacing: 20) {
                        ForEach(viewModel.chapters, id: \.self) { chapter in
                            Text(chapter.title)
                                .font(.subheadline).bold()
                                .foregroundColor(.secondary)
                            VStack(alignment: .leading, spacing: 16) {
                                ForEach(chapter.sections, id: \.self.ncode) { section in
                                    Button(action: {
                                        if section.ncode != sectionNcode {
                                            viewModel.fetchSection(selectedSection: section.ncode)
                                        }
                                        self.presentationMode.wrappedValue.dismiss()
                                    }) {
                                        Text(section.title)
                                            .font(.body)
                                            .foregroundColor(
                                                section.ncode == sectionNcode
                                                    ? Color(.systemBlue)
                                                    : .primary
                                            )
                                    }
                                    .onAppear() {
                                        if section.ncode == sectionNcode {
                                            scrollOffset.scrollTo(sectionNcode)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarTitle(viewModel.novelTitle, displayMode: .inline)
            .navigationBarItems(
                leading: Rectangle().frame(width: 0),
                trailing: dismissButton
            )
        }
    }
}

struct SectionNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        SectionNavigationView(sectionNcode: .constant("n9669bk/1"), handleFetchSection: { _ in })
    }
}
