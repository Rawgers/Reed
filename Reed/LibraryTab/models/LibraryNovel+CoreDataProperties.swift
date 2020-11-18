//
//  LibraryNovel+CoreDataProperties.swift
//  Reed
//
//  Created by Roger Luo on 11/9/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//
//

import Foundation
import CoreData


extension LibraryNovel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LibraryNovel> {
        return NSFetchRequest<LibraryNovel>(entityName: "LibraryNovel")
    }

    @NSManaged private var novelAuthor: String?
    @NSManaged private var novelIsFavorite: Bool
    @NSManaged private var novelNcode: String?
    @NSManaged private var novelSubgenre: Int16
    @NSManaged private var novelTitle: String?
    @NSManaged private var novelLastReadSection: LibrarySection?
    
    var ncode: String {
        get { novelNcode ?? "" }
        set { novelNcode = newValue }
    }
    
    var title: String {
        get { novelTitle ?? "" }
        set { novelTitle = newValue }
    }
    
    var author: String {
        get { novelAuthor ?? "" }
        set { novelAuthor = newValue }
    }
    
    var subgenre: Int {
        get { Int(novelSubgenre) }
        set { novelSubgenre = Int16(newValue) }
    }
    
    var isFavorite: Bool {
        get { novelIsFavorite }
        set { novelIsFavorite = newValue }
    }
    
    var lastReadSection: LibrarySection? {
        get { novelLastReadSection }
        set { novelLastReadSection = newValue }
    }
}

extension LibraryNovel : Identifiable {

}
