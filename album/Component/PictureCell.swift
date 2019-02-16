//
//  PictureCell.swift
//  album
//
//  Created by hiyoko on 2019/02/16.
//  Copyright © 2019年 hiyoko. All rights reserved.
//

import UIKit

class PictureCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    func setup(picture: AlbumModel) {
        let data = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0]
        let path = FileManager.default.contents(atPath: data + "/image/" + picture.path)
        
        imageView.image = UIImage(data: path!)
        imageView.layer.cornerRadius = 4
        imageView.clipsToBounds = true
    }
}
