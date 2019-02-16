//
//  AlbumViewModel.swift
//  album
//
//  Created by hiyoko on 2019/02/15.
//  Copyright © 2019年 hiyoko. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources

class AlbumViewModel {
    
    let albumSectionList: Variable<[AlbumSectionModel]> = Variable([])
    
    private let albumLineNum = 3
    
    func load() {
        let coreData = CoreDataRepository<Album>(query: Album.fetchRequest())
        let albumModelList: [AlbumModel] = coreData.load()
        albumSectionList.value = [AlbumSectionModel(header: 0, items: albumModelList)]
    }
    
    func insert(paths: [String]) {
        paths.forEach { path in
            let coreData = CoreDataRepository<Album>(query: Album.fetchRequest())
            let _ = coreData.insert(entityName: "Album", params: (key: "path", value: path))
        }
    }
}
