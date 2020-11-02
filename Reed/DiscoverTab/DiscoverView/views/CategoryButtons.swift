//
//  CategoryButtons.swift
//  Reed
//
//  Created by Roger Luo on 10/30/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import SwiftUI

struct CategoryButtons: View {
    @Binding var activeCategory: DiscoverListCategory
    @ObservedObject var viewModel = CategoryButtonsViewModel()
    
    var body: some View {
        HStack {
            ForEach(viewModel.buttonCategories, id: \.self.id) { category in
                Button(category.id) { activeCategory = category }
                .padding(.horizontal, 4)
                .padding(4)
                .background(
                    Color(category == activeCategory ? .systemGray3 : .clear)
                )
                .cornerRadius(10)
            }
        }
        .padding()
        .background(Color(.systemGray5))
        .cornerRadius(10)
        .padding(.vertical)
    }
}

struct CategoryButtons_Previews: PreviewProvider {
    static var previews: some View {
        CategoryButtons(activeCategory: .constant(.recent))
    }
}
