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
    @State private var isBottomSheetExpanded: Bool = false
    @State private var definitionEntryIndex: Int = 0
    @State private var tabViewId: UUID = UUID()
    @Binding var entries: [DefinitionDetails]
    
    init(entries: Binding<[DefinitionDetails]>) {
        self._entries = entries
        UIPageControl.appearance().currentPageIndicatorTintColor = .systemGray
        UIPageControl.appearance().pageIndicatorTintColor = .systemGray4
    }
    
    var body: some View {
        if entries.isEmpty {
            VStack {
                Text("Tap on a word!")
                    .foregroundColor(.primary)
                    .italic()
                    .padding(.top, 24)
                
                Spacer()
                
                Text("単語をタップしてみて！")
                    .foregroundColor(.primary)
                    .italic()
                    .padding(.bottom, 144)
            }
        } else {
            TabView(selection: $definitionEntryIndex) {
                ForEach(entries.indices, id: \.self) { i in
                    DefinerTab(entry: entries[i])
                }
            }
            .tabViewStyle(.page)
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
