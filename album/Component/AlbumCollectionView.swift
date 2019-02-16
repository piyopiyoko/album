//
//  AlbumCollectionView.swift
//  album
//
//  Created by hiyoko on 2019/02/15.
//  Copyright © 2019年 hiyoko. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

class AlbumCollectionView: UICollectionView {
    
    let collectionDataSource = RxCollectionViewSectionedAnimatedDataSource<AlbumSectionModel>(configureCell: { (_, collection: UICollectionView, indexPath: IndexPath, element: AlbumModel) in
        let cell = collection.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! AlbumCell
        cell.setup(album: element)
        return cell
    })
    
    weak var albumSelectDelegate: AlbumSelectDelegate?
    fileprivate var viewModel: AlbumViewModel? = nil
    private let disposeBag = DisposeBag()
 
    func setup(viewModel: AlbumViewModel, albumSelectDelegate: AlbumSelectDelegate) {
        self.viewModel = viewModel
        self.albumSelectDelegate = albumSelectDelegate
        delegate = self
        
        let nib = UINib(nibName: "AlbumCell", bundle: nil)
        register(nib, forCellWithReuseIdentifier: "cell")
        
        viewModel.load()
        
        collectionDataSource.configureCell = {(_, collection: UICollectionView, indexPath: IndexPath, element: AlbumModel) in
            let cell = collection.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! AlbumCell
            cell.setup(album: element)
            return cell
        }
        
        collectionDataSource.animationConfiguration = AnimationConfiguration(insertAnimation: .bottom, reloadAnimation: .fade, deleteAnimation: .fade)
        
        viewModel.albumSectionList.asObservable().bind(to: rx.items(dataSource: collectionDataSource)).disposed(by: disposeBag)
    }
}

extension AlbumCollectionView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let list = viewModel?.albumSectionList.value else { return }
        guard let album = (list.filter { albumSection in
                albumSection.header == indexPath.section
        }.first?.items[indexPath.row]) else { return }
        albumSelectDelegate?.didSelect(albumModel: album)
    }
}

extension AlbumCollectionView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (frame.width - 10 * 4) / 3
        let height = width / 2 * 3
        return CGSize(width: width, height: height)
    }
}
