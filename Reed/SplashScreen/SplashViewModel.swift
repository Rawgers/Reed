//
//  SplashViewModel.swift
//  Reed
//
//  Created by Roger Luo on 9/20/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import SwiftUI


class SplashViewModel: ObservableObject {
    
    @Published var loadingText: String = "Loading"
    @Published var isSplashActive: Bool = true
    
    let dictionaryParser: DictionaryParser = DictionaryParser()
    var numEllipses: Int = 0
    var timer: Timer?
    
    func viewDidAppear() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didFinishLoadingDictionary(_:)),
            name: .didFinishLoadingDictionary,
            object: nil
        )
        if !hasDictionary() {
            animateLoadingText()
            loadData()
        }
    }
    
    func dismissSplash() {
        withAnimation() {
            self.isSplashActive = false
        }
    }
    
    func loadData() {
        let container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
        let dictionaryStorageManager = DictionaryStorageManager(container: container)
        let dictionaryParser = DictionaryParser(storageManager: dictionaryStorageManager)

        DispatchQueue.global(qos: .userInitiated).async {
            dictionaryParser.storageManager.flushAll()
            if let dictionaryData = try? dictionaryParser.readInDictionaryData() {
                dictionaryParser.parseAndLoad(dictionaryData: dictionaryData)
            }
            self.timer?.invalidate()
        }
    }
    
    func animateLoadingText() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            self.loadingText = "Loading" + String.init(repeating: ".", count: self.numEllipses)
            self.numEllipses = (self.numEllipses + 1) % 4
        }
    }
    
    func hasDictionary() -> Bool {
        return UserDefaults.standard.bool(forKey: "hasDictionary")
    }
    
    @objc func didFinishLoadingDictionary(_ notification: Notification) {
        DispatchQueue.main.async {
            UserDefaults.standard.set(true, forKey: "hasDictionary")
            self.dismissSplash()
        }
    }
    
}
