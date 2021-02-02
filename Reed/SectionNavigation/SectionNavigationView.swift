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
    
    init(sectionNcode: String) {
        viewModel = SectionNavigationViewModel(sectionNcode: sectionNcode)
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
                            .foregroundColor(Color(.systemGray3))
                        VStack(alignment: .leading, spacing: 16) {
                            ForEach(chapter.sections, id: \.self) { section in
                                Text(section.title)
                                    .font(.body)
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
        SectionNavigationView(sectionNcode: "n9669bk/1")
    }
}
