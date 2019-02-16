//
//  CameraRollViewController.swift
//  album
//
//  Created by hiyoko on 2019/02/16.
//  Copyright © 2019年 hiyoko. All rights reserved.
//

import UIKit

class CameraRollViewController: UIViewController, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private var updatePath = ""
    weak private var pictureReceiveDelegate: PictureReceiveDelegate?
    
    init(pictureReceiveDelegate: PictureReceiveDelegate?) {
        super.init(nibName: nil, bundle: nil)
        self.pictureReceiveDelegate = pictureReceiveDelegate
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        pickImageFromLibrary()
    }
    
    // ライブラリから写真を選択する
    func pickImageFromLibrary() {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            
            let controller = UIImagePickerController()
            controller.delegate = self
            controller.sourceType = UIImagePickerController.SourceType.photoLibrary
            
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let pickedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // 90度回転修正
        UIGraphicsBeginImageContext(pickedImage.size)
        pickedImage.draw(in: CGRect(x: 0, y: 0, width: pickedImage.size.width, height: pickedImage.size.height))
        let context = UIGraphicsGetCurrentContext()
        context?.rotate(by: CGFloat(Double.pi / 2))
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if let img = img {
            let nextView = EditPictureViewController.makePictureViewController(picImage: img, pictureReceiveDelegate: pictureReceiveDelegate)
            self.navigationController?.pushViewController(nextView, animated: true)
        }
        
        self.dismiss(animated: false, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: false)
    }
}
