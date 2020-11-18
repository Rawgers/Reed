//
//  View+Print.swift
//  Reed
//
//  Created by Roger Luo on 11/14/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import SwiftUI

extension View {
    func Print(_ vars: Any...) -> some View {
        for v in vars { print(v) }
        return EmptyView()
    }
}
