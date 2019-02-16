//
//  SelectPictureDelegate.swift
//  album
//
//  Created by hiyoko on 2019/02/16.
//  Copyright © 2019年 hiyoko. All rights reserved.
//

import UIKit

protocol SelectPictureDelegate: class {
    
    func showSelectPictureAlert(pictureReceiveDelegate: PictureReceiveDelegate?)
}

extension SelectPictureDelegate where Self: UIViewController {
    
    func showSelectPictureAlert(pictureReceiveDelegate: PictureReceiveDelegate?) {
        
        let alert = UIAlertController(
            title: "",
            message: "写真選択",
            preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "カメラ起動", style: .default, handler: { [unowned self] action in
            
            if let nextView = CameraViewController.makeCameraViewController(pictureReceiveDelegate: pictureReceiveDelegate) {
                self.navigationController?.pushViewController(nextView, animated: true)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "カメラロールから選択", style: .default, handler: { [unowned self] action in
            
            let nextView = CameraRollViewController(pictureReceiveDelegate: pictureReceiveDelegate)
            self.navigationController?.pushViewController(nextView, animated: false)
        }))
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: { action in
            
        }))
        
        UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
    }
}

extension UIApplication {
    // 最前画面を取得する
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
