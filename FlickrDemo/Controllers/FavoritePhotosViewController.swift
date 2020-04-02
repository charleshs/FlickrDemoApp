//
//  FavoritePhotosViewController.swift
//  FlickrDemo
//
//  Created by Charles Hsieh on 2020/4/3.
//  Copyright © 2020 Charles Hsieh. All rights reserved.
//

import UIKit

class FavoritePhotosViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            setupCollectionView()
        }
    }
    
    private let numberOfColumns: Int = 2
    private let heightToWidthRatio: CGFloat = 1.25
    
    private var photoList: [PhotoPresentable] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadData()
            }
        }
    }
    
    private var photoListObservation: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchPhotoList()
        
        photoListObservation = StorageManager.shared.observe(
            \.photoList,
            options: [.new],
            changeHandler: { [weak self] (_, change) in
                if let photos = change.newValue {
                    self?.photoList = photos.compactMap { $0.converted() }
                }
        })
    }
    
    private func fetchPhotoList() {
        
        StorageManager.shared.fetchPhoto { [weak self] (result) in
            switch result {
            case let .success(photos):
                self?.photoList = photos.compactMap { $0.converted() }
            case let .failure(error):
                print(error)
            }
        }
    }
    
    private func setupCollectionView() {
        
        collectionView.csRegisterNibCell(nibClassType: PhotoCollectionViewCell.self)
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}

extension FavoritePhotosViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return photoList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
                PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell
            else {
                return UICollectionViewCell()
        }
        
        let photo = photoList[indexPath.item]

        cell.likeButton.isHidden = true
        cell.configureCell(title: photo.title, image: photo.urlString)
        
        return cell
    }
}

extension FavoritePhotosViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let itemSpacing = flowLayout.minimumInteritemSpacing
        let totalWidth = collectionView.frame.width
        let horizontalIndent = collectionView.contentInset.left + collectionView.contentInset.right
        let resolvedWidth = totalWidth - itemSpacing * CGFloat(numberOfColumns - 1) - horizontalIndent
        let itemWidth = resolvedWidth / CGFloat(numberOfColumns)
        
        return CGSize(width: itemWidth, height: itemWidth * heightToWidthRatio)
    }
}
