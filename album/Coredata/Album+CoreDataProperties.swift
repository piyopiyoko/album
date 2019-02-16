//
//  Album+CoreDataProperties.swift
//  
//
//  Created by hiyoko on 2019/02/16.
//
//

import Foundation
import CoreData


extension Album {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Album> {
        return NSFetchRequest<Album>(entityName: "Album")
    }

    @NSManaged public var id: Int64
    @NSManaged public var order: Int64
    @NSManaged public var path: String?
    @NSManaged public var albumId: NSSet?

}

// MARK: Generated accessors for albumId
extension Album {

    @objc(addAlbumIdObject:)
    @NSManaged public func addToAlbumId(_ value: Picture)

    @objc(removeAlbumIdObject:)
    @NSManaged public func removeFromAlbumId(_ value: Picture)

    @objc(addAlbumId:)
    @NSManaged public func addToAlbumId(_ values: NSSet)

    @objc(removeAlbumId:)
    @NSManaged public func removeFromAlbumId(_ values: NSSet)

}
