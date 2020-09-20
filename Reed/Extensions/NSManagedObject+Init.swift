//
//  NSManagedObject+Init.swift
//  Reed
//
//  Created by Roger Luo on 9/14/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import CoreData

public extension NSManagedObject {
    
    /**
     In order to use NSManagedObject instances in unit tests, CoreData is granted target membership in both Reed and ReedTests.
     This causes NSManagedObjects subclasses to be confused about whether their provided contexts
     are from Reed or ReedTests, resulting in ambigous context warnings.
     Using this constructor will disabiguate the context at runtime.
     */
    convenience init(using usedContext: NSManagedObjectContext) {
    let name = String(describing: type(of: self))
    let entity = NSEntityDescription.entity(forEntityName: name, in: usedContext)!
    self.init(entity: entity, insertInto: usedContext)
    }
}
