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
    
    public var photoListProvider: PhotoListProvider?
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            setupCollectionView()
        }
    }
    
    private var isFetchingNextPage: Bool = false
    private var currentPage: Int = 1
    
    private var photoList: [PhotoInterface] = [] {
        didSet {
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
    
    private func fetchPhotoList(page: Int = 1) {
        
        photoListProvider?.fetchPhotoList(page: page) { [weak self] (result) in
            switch result {
            case let .success(photos):
                self?.photoList.append(contentsOf: photos)
                self?.currentPage = page
            case let .failure(error):
                print(error)
            }
            self?.isFetchingNextPage = false
        }
    }
    
    private func setupCollectionView() {
        
        collectionView.csRegisterNibCell(nibClassType: PhotoCollectionViewCell.self)
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}

extension SearchResultViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        return photoList.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
                PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell
            else {
                return UICollectionViewCell()
        }
        let photo = photoList[indexPath.item]
        cell.configureCell(title: photo.title, image: photo.urlString)
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let yOffset = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if yOffset > (contentHeight - scrollView.frame.height * 2), !isFetchingNextPage {
            self.isFetchingNextPage = true
            self.fetchPhotoList(page: currentPage + 1)
        }
    }
}
