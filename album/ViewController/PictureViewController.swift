//
//  PictureViewController.swift
//  album
//
//  Created by hiyoko on 2019/02/16.
//  Copyright © 2019年 hiyoko. All rights reserved.
//
import UIKit

class PictureViewController: UIViewController {
    
    @IBOutlet weak var collectionView: PictureCollectionView!
    
    private var viewModel = PictureViewModel()
    
    static func makePictureViewController(albumId: Int) -> PictureViewController {
        
        let nextView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PictureViewController") as! PictureViewController
        nextView.viewModel.albumId = albumId
        
        return nextView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
        collectionView.setup(viewModel: viewModel)
    }
    
    private func setupNavigation() {
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.title = "アルバムの写真"
        let buttonHeight = navigationController!.navigationBar.frame.size.height - 10
        
        let button = AddButton(frame: CGRect(x: 0, y: 0, width: buttonHeight, height: buttonHeight), selectPictureDelegate: self, pictureReceiveDelegate: self)
        let addButtonItem = UIBarButtonItem.init(customView: button)
        
        navigationItem.setRightBarButtonItems([addButtonItem], animated: true)
    }
}

extension PictureViewController: SelectPictureDelegate {
}

extension PictureViewController: PictureReceiveDelegate {
    func receivePicture(paths: [String]) {
        viewModel.insert(paths: paths)
        viewModel.load()
    }
}
