//
//  NavigationBackChevron.swift
//  Reed
//
//  Created by Roger Luo on 1/20/21.
//  Copyright © 2021 Roger Luo. All rights reserved.
//

import SwiftUI

struct NavigationBackChevron: View {
    let label: String
    let handleDismiss: () -> Void
    
    var body: some View { Button(action: {
        handleDismiss()
    }) {
        HStack {
            Image(systemName: "chevron.backward")
                .imageScale(.large)
            Text(label)
                .font(.callout)
                .fontWeight(.regular)
        }
    }}
}

struct NavigationBackChevron_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBackChevron(label: "Back", handleDismiss: {})
    }
}
