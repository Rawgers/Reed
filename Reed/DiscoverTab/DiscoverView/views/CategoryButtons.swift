//
//  CategoryButtons.swift
//  Reed
//
//  Created by Roger Luo on 10/30/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import SwiftUI

struct CategoryButtons: View {
    @ObservedObject var viewModel = CategoryButtonsViewModel()
    @Binding var activeCategory: DiscoverListCategory
    let updateCategory: (DiscoverListCategory) -> Void
    
    var body: some View {
        HStack(alignment: .lastTextBaseline) {
            ForEach(viewModel.buttonCategories, id: \.self) { category in
                categoryButton(of: category)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
        .padding(.vertical)
    }
    
    @ViewBuilder
    func categoryButton(of category: DiscoverListCategory) -> some View {
        Button(action: {
            if category != activeCategory {
                updateCategory(category)
            }
        }) {
            let (label, icon) = viewModel.buttonData[category] ?? ("", "")
            VStack {
                Image(systemName: category == activeCategory ? icon + ".fill" : icon)
                    .imageScale(.large)
                    .padding(.vertical, 4)
                Text(label)
                    .font(.system(size: 8))
            }
        }
//        .padding(.horizontal, 4)
        .padding(4)
//        .background(
//            Color(category == activeCategory ? .systemGray3 : .clear)
//        )
        .cornerRadius(10)
    }
}

struct CategoryButtons_Previews: PreviewProvider {
    static var previews: some View {
        CategoryButtons(
            activeCategory: .constant(.recent),
            updateCategory: { _ in }
        )
    }
}
