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
    
    init(
        sectionNcode: String,
        handleFetchSection: @escaping (String) -> Void
    ) {
        viewModel = SectionNavigationViewModel(
            sectionNcode: sectionNcode,
            handleFetchSection: handleFetchSection
        )
    }
    
    var dismissButton: some View {
        Button("Done") {
            self.presentationMode.wrappedValue.dismiss()
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 20) {
                    ForEach(viewModel.chapters, id: \.self) { chapter in
                        Text(chapter.title)
                            .font(.subheadline).bold()
                            .foregroundColor(.secondary)
                        VStack(alignment: .leading, spacing: 16) {
                            ForEach(chapter.sections, id: \.self) { section in
                                Button(action: {
                                    print(section.ncode, viewModel.sectionNcode)
                                    if section.ncode != viewModel.sectionNcode {
                                        viewModel.fetchSection(selectedSection: section.ncode)
                                    }
                                    self.presentationMode.wrappedValue.dismiss()
                                }) {
                                    Text(section.title)
                                        .font(.body)
                                        .foregroundColor(
                                            section.ncode == viewModel.sectionNcode
                                                ? Color(.systemBlue)
                                                : .primary
                                        )
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarTitle(viewModel.novelTitle, displayMode: .inline)
            .navigationBarItems(
                leading: EmptyView(),
                trailing: dismissButton
            )
        }
    }
}

struct SectionNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        SectionNavigationView(sectionNcode: "n9669bk/1", handleFetchSection: { _ in })
    }
}
