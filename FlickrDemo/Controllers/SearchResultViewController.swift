//
//  SearchResultViewController.swift
//  FlickrDemo
//
//  Created by Charles Hsieh on 2020/3/31.
//  Copyright © 2020 Charles Hsieh. All rights reserved.
//

import UIKit

class SearchResultViewController: UIViewController, Storyboarded {
    
    static var storyboard: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    public var photoSearcher: PhotoSearchable?
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            setupCollectionView()
        }
    }
    
    private var photos: Photos? {
        didSet {
            guard photos != nil else { return }
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadData()
            }
        }
    }
    
    private let numberOfColumns: Int = 2
    private let heightToWidthRatio: CGFloat = 1.25
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchPhotoList()
    }
    
    private func fetchPhotoList() {
        
        photoSearcher?.fetchPhotoList(completion: { (result) in
            switch result {
            case let .success(photos):
                self.photos = photos
            case let .failure(error):
                print(error)
            }
        })
    }
    
    private func setupCollectionView() {
        
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}

extension SearchResultViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
                PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell
            else {
                return UICollectionViewCell()
        }
        
        return cell
    }
}

extension SearchResultViewController: UICollectionViewDelegateFlowLayout {
    
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
