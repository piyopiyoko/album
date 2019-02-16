//
//  AlbumCell.swift
//  album
//
//  Created by hiyoko on 2019/02/15.
//  Copyright © 2019年 hiyoko. All rights reserved.
//

import UIKit

@IBDesignable
class PictureEditPanel: UIView {
    
    @IBOutlet weak var finishButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var rotateButton: UIButton!
    
    @IBOutlet weak var trimButton: UIButton!
    
    var height : CGFloat = 0
    var posY : CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadXib()
        
        height = frame.height
        posY = UIScreen.main.bounds.height - frame.height
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        loadXib()
    }
    
    // 初期化
    fileprivate func loadXib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "PictureEditPanel", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        let bindings = ["view": view]
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:nil, views: bindings))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:nil, views: bindings))
        
    }
}
