//
//  AlbumCell.swift
//  album
//
//  Created by hiyoko on 2019/02/15.
//  Copyright © 2019年 hiyoko. All rights reserved.
//

import UIKit

class AlbumCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    func setup(album: AlbumModel) {
        let data = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0]
        let path = FileManager.default.contents(atPath: data + "/image/" + album.path)
        
        imageView.image = UIImage(data: path!)
        imageView.frame = calcFrame(image: imageView.image!)
        imageView.layer.cornerRadius = 4
        imageView.clipsToBounds = true
    }
    
    private func calcFrame(image: UIImage) -> CGRect {
        
        let topMargin: CGFloat = 10
        let baseHeight = frame.size.height - topMargin
        let scaleW = frame.size.width / image.size.width
        let scaleH = baseHeight / image.size.height
        
        var width = image.size.width
        var height = image.size.height
        if(scaleW < scaleH) {
            width *= scaleW
            height *= scaleW
        }
        else {
            width *= scaleH
            height *= scaleH
        }
        
        return CGRect(x: (frame.size.width - width) / 2,
                      y: baseHeight - height + topMargin,
                      width: width, height: height)
    }
}
