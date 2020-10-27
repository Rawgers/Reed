//
//  View+UIKitComponents.swift
//  Reed
//
//  Created by Roger Luo on 10/26/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import SwiftUI

extension View {
    func navigationBarSearchController(
        from searchBar: SearchBar,
        hidesWhenScrolling: Bool
    ) -> some View {
        return self.modifier(SearchBarModifier(
            searchBar: searchBar,
            hidesWhenScrolling: hidesWhenScrolling
        ))
    }
}
