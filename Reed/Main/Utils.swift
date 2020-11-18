//
//  Utils.swift
//  Reed
//
//  Created by Roger Luo on 11/17/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import CoreData
import SwiftUI

func getSharedPersistentContainer() -> NSPersistentContainer {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        fatalError("Could not get shared app delegate.")
    }
    return appDelegate.persistentContainer
}
