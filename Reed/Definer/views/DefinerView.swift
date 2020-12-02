//
//  DefinitionModal.swift
//  Reed
//
//  Created by Roger Luo on 9/9/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import SwiftUI
import SwiftUIPager

struct DefinerView: View {
    @Binding var entries: [DefinitionDetails]
    @State private var isBottomSheetExpanded = false
    @State private var definitionEntryIndex = 0
    @State private var tabViewId = UUID()
    
    var body: some View {
        BottomSheetView (isOpen: self.$isBottomSheetExpanded) {
            if !entries.isEmpty {
                TabView(selection: $definitionEntryIndex) {
                    ForEach(entries, id: \.self) { entry in
                        DefinerTab(entry: entry)
                    }
                }
                .tabViewStyle(PageTabViewStyle())
                .onChange(of: entries) { value in
                    definitionEntryIndex = 0
                    tabViewId = UUID()
                }
                .id(tabViewId)
                .padding(.horizontal)
            }
        }
        .ignoresSafeArea()
    }
}

struct DefinerView_Previews: PreviewProvider {
    static var previews: some View {
        DefinerView(entries: .constant([]))
    }
}
