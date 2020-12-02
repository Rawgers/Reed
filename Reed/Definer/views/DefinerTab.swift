//
//  DefinitionDetailsView.swift
//  Reed
//
//  Created by Hugo Zhan on 11/24/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import SwiftUI

struct DefinerTab: View {
    let entry: DefinitionDetails
    
    var body: some View {
        ScrollView {
            VStack {
                HStack(alignment: .lastTextBaseline, spacing: 16) {
                    Text(entry.title)
                        .font(.title2)
                        .bold()
                    Text("\(entry.primaryReading)")
                        .font(.footnote)
                        .padding(.trailing)
                    Spacer()
                }
                .padding(.vertical, 4)
                
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(0..<entry.definitions.endIndex, id: \.self) { i in
                        HStack(alignment: .firstTextBaseline) {
                            Text("\(i + 1).")
                                .frame(width: 35, alignment: .trailing)
                            HStack(alignment: .lastTextBaseline, spacing: 8) {
                                Text(entry.definitions[i].definition)
                                    .fixedSize(horizontal: false, vertical: true)
                                Text("\(entry.definitions[i].specicificLexemes)")
                                    .font(.footnote)
                                    .foregroundColor(Color(.systemGray3))
                                Spacer()
                            }
                        }
                    }
                }
                .padding(.leading, -20)
                .padding(.bottom, 12)
                
                if !entry.terms.isEmpty {
                    Divider()
                    
                    HStack {
                        Text("OTHER FORMS")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(Color(.systemGray4))
                        Spacer()
                    }
                    .padding(.bottom, 4)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(entry.terms, id: \.self) { term in
                            HStack(alignment: .lastTextBaseline) {
                                Text("\(term.term)")
                                    .padding(.horizontal)
                                Text("\(term.reading)")
                                    .font(.footnote)
                                    .foregroundColor(Color(.systemGray3))
                                    .padding(.trailing)
                                Spacer()
                            }
                            .padding(.bottom, 4)
                        }
                    }
                    .padding(.leading, -16)
                }
            }
        }
    }
}

struct DefinerTab_Previews: PreviewProvider {
    static var previews: some View {
        DefinerTab(
            entry: DefinitionDetails(
                title: "",
                primaryReading: "",
                terms: [],
                definitions: []
            )
        )
    }
}
