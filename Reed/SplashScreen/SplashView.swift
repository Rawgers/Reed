//
//  SplashView.swift
//  Reed
//
//  Created by Roger Luo on 9/20/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import SwiftUI


struct SplashView: View {
    @ObservedObject var viewModel: SplashViewModel = SplashViewModel()
    
    var body: some View {
        VStack {
            if viewModel.isSplashActive {
                Text("Welcome to Reed!")
                    .font(Font.largeTitle)
                Text(viewModel.loadingText)
            } else {
                AppView()
            }
        }
        .onAppear {
            if self.viewModel.hasDictionary() {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self.viewModel.dismissSplash()
                }
            } else {
                self.viewModel.viewDidAppear()
            }
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
