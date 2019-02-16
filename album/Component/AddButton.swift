//
//  AddButton.swift
//  album
//
//  Created by hiyoko on 2019/02/16.
//  Copyright © 2019年 hiyoko. All rights reserved.
//

import UIKit

class AddButton: UIButton {
    
    weak var selectPictureDelegate: SelectPictureDelegate?
    weak var pictureReceiveDelegate: PictureReceiveDelegate?
    
    init(frame: CGRect, selectPictureDelegate: SelectPictureDelegate) {
        super.init(frame: frame)
        initialize(frame: frame, selectPictureDelegate: selectPictureDelegate)
    }
    
    init(frame: CGRect, selectPictureDelegate: SelectPictureDelegate, pictureReceiveDelegate: PictureReceiveDelegate) {
        super.init(frame: frame)
        self.pictureReceiveDelegate = pictureReceiveDelegate
        initialize(frame: frame, selectPictureDelegate: selectPictureDelegate)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup(selectPictureDelegate: SelectPictureDelegate, pictureReceiveDelegate: PictureReceiveDelegate) {
        
        self.pictureReceiveDelegate = pictureReceiveDelegate
        initialize(frame: frame, selectPictureDelegate: selectPictureDelegate)
    }
    
    private func initialize(frame: CGRect, selectPictureDelegate: SelectPictureDelegate) {
        self.selectPictureDelegate = selectPictureDelegate
        
        var image : UIImage?
        image = UIImage(named: "plus")
        
        imageView?.contentMode = .scaleAspectFit
        
        super.addTarget(self, action: #selector(plusClick(_:)), for: .touchUpInside)
        super.setImage(image, for: UIControl.State.normal)
    }
    
    @objc func plusClick(_ sender:UITapGestureRecognizer) {
        
        selectPictureDelegate?.showSelectPictureAlert(pictureReceiveDelegate: pictureReceiveDelegate)
    }
}
