//
//  File.swift
//  ReedTests
//
//  Created by Roger Luo on 9/14/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import CoreData

func createMockPersistentContainer(model: NSManagedObjectModel) -> NSPersistentContainer {
    
    let container = NSPersistentContainer(
        name: "mockContainer",
        managedObjectModel: model
    )
    let description = NSPersistentStoreDescription()
    description.type = NSInMemoryStoreType
    description.shouldAddStoreAsynchronously = false
    
    container.persistentStoreDescriptions = [description]
    container.loadPersistentStores { (description, error) in
        // Check if the data store is in memory
        precondition( description.type == NSInMemoryStoreType )
                                    
        // Check if creating container wrong
        if let error = error {
            fatalError("Create an in-mem coordinator failed \(error)")
        }
    }
    
    return container
}
