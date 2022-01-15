//
//  NavigationLinkRightChevron.swift
//  Reed
//
//  Created by Roger Luo on 1/14/22.
//  Copyright © 2022 Roger Luo. All rights reserved.
//

import SwiftUI

struct NavigationLinkRightChevron<Content: View>: View {
    let destination: () -> Content
    
    init(@ViewBuilder destination: @escaping () -> Content) {
        self.destination = destination
    }
    
    var body: some View {
        NavigationLink(
            destination: NavigationLazyView(destination())
        ) {
            Image(systemName: "chevron.right")
                .frame(width: 32, height: 48)
                .imageScale(.medium)
                .foregroundColor(Color(UIColor.systemBlue))
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(8)
        }
    }
}
