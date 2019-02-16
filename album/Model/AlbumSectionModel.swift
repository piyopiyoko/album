//
//  AlbumSectionModel.swift
//  album
//
//  Created by hiyoko on 2019/02/15.
//  Copyright © 2019年 hiyoko. All rights reserved.
//

import Foundation
import RxDataSources

struct AlbumSectionModel {
    var header: Int
    var items: [AlbumModel]
}

extension AlbumSectionModel: AnimatableSectionModelType {
    
    typealias Item = AlbumModel
    
    var identity: Int {
        return header
    }
    
    init(original: AlbumSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
    
}
