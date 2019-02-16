//
//  PictureViewModel.swift
//  album
//
//  Created by hiyoko on 2019/02/16.
//  Copyright © 2019年 hiyoko. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources

class PictureViewModel {
    
    let pictureSectionList: Variable<[AlbumSectionModel]> = Variable([])
    
    private let pictureLineNum = 3
    var albumId = 0
    
    func setAlbumId(id: Int) {
        albumId = id
    }
    
    func load() {
        let coreData = CoreDataRepository<Picture>(query: Picture.fetchRequest())
        let pictureModelList: [AlbumModel] = coreData.load(predicate: NSPredicate(format: "album.id=%d", albumId))
        pictureSectionList.value = [AlbumSectionModel(header: 0, items: pictureModelList)]
    }
    
    func insert(paths: [String]) {
        paths.forEach { path in
            let coreData = CoreDataRepository<Album>(query: Album.fetchRequest())
            let _ = coreData.insert(entityName: "Picture", fetchRequest: Album.fetchRequest(), predicate: NSPredicate(format: "id == %d", albumId), relationName: "album", params: (key: "path", value: path))
        }
    }
}
