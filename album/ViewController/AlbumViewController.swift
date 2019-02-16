//
//  AlbumViewController.swift
//  album
//
//  Created by hiyoko on 2019/02/15.
//  Copyright © 2019年 hiyoko. All rights reserved.
//

import UIKit

class AlbumViewController: UIViewController {

    @IBOutlet weak var collectionView: AlbumCollectionView!
    
    fileprivate let viewModel = AlbumViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
        collectionView.setup(viewModel: viewModel, albumSelectDelegate: self)
    }

    private func setupNavigation() {
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.title = "アルバムの表紙"
        let buttonHeight = navigationController!.navigationBar.frame.size.height - 10
        
        let button = AddButton(frame: CGRect(x: 0, y: 0, width: buttonHeight, height: buttonHeight), selectPictureDelegate: self, pictureReceiveDelegate: self)
        let addButtonItem = UIBarButtonItem.init(customView: button)
        
        navigationItem.setRightBarButtonItems([addButtonItem], animated: true)
    }
}

extension AlbumViewController: SelectPictureDelegate {
    
}

extension AlbumViewController: PictureReceiveDelegate {
    func receivePicture(paths: [String]) {
        viewModel.insert(paths: paths)
        viewModel.load()
    }
}

extension AlbumViewController: AlbumSelectDelegate {
    func didSelect(albumModel: AlbumModel) {
        let nextView = PictureViewController.makePictureViewController(albumId: albumModel.id)
        self.navigationController?.pushViewController(nextView, animated: true)
    }
}
