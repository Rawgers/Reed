//
//  Definer.swift
//  Reed
//
//  Created by Roger Luo on 9/9/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import SwiftUI

struct Term: Equatable, Hashable, Identifiable {
    var id = UUID()
    var reading: String
    var term: String
}

struct Definition: Equatable, Hashable, Identifiable {
    var id = UUID()
    var specicificLexemes: String
    var definition: String
}

struct DefinitionDetails: Equatable, Hashable, Identifiable {
    var id = UUID()
    var title: String
    var primaryReading: String
    var terms: [Term]
    var definitions: [Definition]
    
    static func == (lhs: DefinitionDetails, rhs: DefinitionDetails) -> Bool {
        return lhs.definitions == rhs.definitions
    }
}

class DefinerResults: ObservableObject {
    @Published var entries = [DefinitionDetails]()
    
    func updateEntries(entries: [DefinitionDetails]) {
        self.entries = entries
    }
}

struct Definer: View {
    @State private var isBottomSheetExpanded = false
    @State private var definitionEntryIndex = 0
    @State private var tabViewId = UUID()
    @Binding var entries: [DefinitionDetails]
    
    var body: some View {
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
}

struct Definer_Previews: PreviewProvider {
    static var previews: some View {
        Definer(entries: .constant([]))
    }
}
