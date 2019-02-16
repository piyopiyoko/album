//
//  Picture+CoreDataProperties.swift
//  
//
//  Created by hiyoko on 2019/02/16.
//
//

import Foundation
import CoreData


extension Picture {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Picture> {
        return NSFetchRequest<Picture>(entityName: "Picture")
    }

    @NSManaged public var id: Int64
    @NSManaged public var order: Int64
    @NSManaged public var path: String?
    @NSManaged public var album: Album?

}
