//
//  LibraryNovel+CoreDataClass.swift
//  Reed
//
//  Created by Roger Luo on 11/5/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//
//

import Foundation
import CoreData

@objc(LibraryNovel)
public class LibraryNovel: NSManagedObject {
    static func create(
        context: NSManagedObjectContext,
        ncode: String,
        title: String,
        author: String,
        subgenre: Int,
        isFavorite: Bool
    ) -> LibraryNovel? {
        let libraryNovel = LibraryNovel(using: context)
        libraryNovel.ncode = ncode
        libraryNovel.title = title
        libraryNovel.author = author
        libraryNovel.subgenre = subgenre
        libraryNovel.isFavorite = isFavorite
        
        let librarySection = LibrarySection(using: context)
        librarySection.id = 0
        librarySection.novel = libraryNovel
        libraryNovel.lastReadSection = librarySection
        do {
            try context.save()
        } catch {
            print("Unable to save to library due to error: \(error.localizedDescription)")
            return nil
        }
        
        return libraryNovel
    }
}
