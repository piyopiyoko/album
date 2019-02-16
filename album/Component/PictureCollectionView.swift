//
//  PictureCollectionView.swift
//  album
//
//  Created by hiyoko on 2019/02/16.
//  Copyright © 2019年 hiyoko. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

class PictureCollectionView: UICollectionView {
    
    let collectionDataSource = RxCollectionViewSectionedAnimatedDataSource<AlbumSectionModel>(configureCell: { (_, collection: UICollectionView, indexPath: IndexPath, element: AlbumModel) in
        let cell = collection.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PictureCell
        cell.setup(picture: element)
        return cell
    })
    
    weak var albumSelectDelegate: AlbumSelectDelegate?
    fileprivate var viewModel: PictureViewModel? = nil
    private let disposeBag = DisposeBag()
    
    func setup(viewModel: PictureViewModel) {
        self.viewModel = viewModel
        delegate = self
        
        let nib = UINib(nibName: "PictureCell", bundle: nil)
        register(nib, forCellWithReuseIdentifier: "cell")
        
        viewModel.load()
        
        collectionDataSource.animationConfiguration = AnimationConfiguration(insertAnimation: .bottom, reloadAnimation: .fade, deleteAnimation: .fade)
        
        viewModel.pictureSectionList.asObservable().bind(to: rx.items(dataSource: collectionDataSource)).disposed(by: disposeBag)
    }
}

extension PictureCollectionView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}

extension PictureCollectionView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (frame.width - 10 * 4) / 3
        let height = width
        return CGSize(width: width, height: height)
    }
}
