//
//  AlbumModel.swift
//  album
//
//  Created by hiyoko on 2019/02/15.
//  Copyright © 2019年 hiyoko. All rights reserved.
//

import Foundation
import RxDataSources

struct AlbumModel: AnyObjectModel {
    var id = 0
    var path = ""
    var order = 0
    
    init(obj: AnyObject) {
        id = obj.value(forKey: "id") as! Int
        path = obj.value(forKey: "path") as! String
        order = obj.value(forKey: "order") as! Int
    }
}

extension AlbumModel: IdentifiableType {
    public typealias Identity = Int
    
    public var identity : Identity {
        return self.id
    }
}

extension AlbumModel: Equatable {
    static func ==(lhs: AlbumModel, rhs: AlbumModel) -> Bool {
        return lhs.id == rhs.id
    }
}
