//
//  PictureReceiveDelegate.swift
//  album
//
//  Created by hiyoko on 2019/02/16.
//  Copyright © 2019年 hiyoko. All rights reserved.
//

import Foundation

protocol PictureReceiveDelegate: class {
    
    func receivePicture(paths: [String])
}
