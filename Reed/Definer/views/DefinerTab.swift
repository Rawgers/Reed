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
                HStack(alignment: .lastTextBaseline) {
                    Text(entry.title)
                        .font(.title2)
                        .padding(.horizontal)
                    Text("\(entry.primaryReading)")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .padding(.trailing)
                    Spacer()
                }
                .padding(.vertical)
                
                ForEach(0..<entry.definitions.endIndex, id: \.self) { i in
                    HStack(alignment: .firstTextBaseline) {
                        Text("\(i + 1).")
                            .frame(width: 35, alignment: .trailing)
                        HStack(alignment: .lastTextBaseline) {
                            Text(entry.definitions[i].definition)
                                .padding(.trailing)
                                .fixedSize(horizontal: false, vertical: true)
                            Text("\(entry.definitions[i].specicificLexemes)")
                                .font(.footnote)
                                .foregroundColor(.gray)
                                .padding(.trailing)
                            Spacer()
                        }
                    }
                    .padding(.bottom, 4)
                }
                
                if !entry.terms.isEmpty {
                    VStack{
                        Color.gray.frame(height: 1)
                        HStack {
                            Text("OTHER FORMS")
                                .font(.headline)
                                .foregroundColor(.gray)
                            Spacer()
                        }
                    }
                    .padding()
                }
                
                ForEach(entry.terms, id: \.self) { term in
                    HStack(alignment: .lastTextBaseline) {
                        Text("\(term.term)")
                            .padding(.horizontal)
                        Text("\(term.reading)")
                            .font(.footnote)
                            .foregroundColor(.gray)
                            .padding(.trailing)
                        Spacer()
                    }
                    .padding(.bottom, 4)
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
