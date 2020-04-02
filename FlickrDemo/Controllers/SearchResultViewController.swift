//
//  SearchResultViewController.swift
//  FlickrDemo
//
//  Created by Charles Hsieh on 2020/3/31.
//  Copyright © 2020 Charles Hsieh. All rights reserved.
//

import UIKit

class SearchResultViewController: UIViewController, Storyboarded {
    
    // MARK: - Storyboarded
    static var storyboard: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    // MARK: - Public Vars
    public var photoListProvider: PhotoListProvider?
    public var searchText: String?
    
    // MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            setupCollectionView()
        }
    }
    
    // MARK: - Private Vars
    private var isFetchingNextPage: Bool = false
    private var currentPage: Int = 1
    
    private var photoList: [PhotoPresentable] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadData()
            }
        }
    }
    
    // MARK: - Private Constants
    private let numberOfColumns: Int = 2
    private let heightToWidthRatio: CGFloat = 1.25
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        fetchPhotoList()
    }
    
    // MARK: - Private Methods
    private func setupViews() {
        navigationItem.title = "搜尋結果 \(searchText ?? "")"
    }
    
    private func setupCollectionView() {
        
        collectionView.csRegisterNibCell(nibClassType: PhotoCollectionViewCell.self)
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
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
}

// MARK: - UICollectionViewDataSource
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
        
        cell.likeButton.isSelected = photo.isLiked
        cell.configureCell(title: photo.title, image: photo.urlString, likeAction: { [weak self] (cell) in
            self?.handleLikeAction(for: indexPath)
            cell.likeButton.isSelected = self?.photoList[indexPath.item].isLiked ?? false
        })
        
        return cell
    }
    
    private func handleLikeAction(for indexPath: IndexPath) {
        
        photoList[indexPath.item].isLiked.toggle()
        let updatedPhoto = photoList[indexPath.item]
        if updatedPhoto.isLiked {
            savePhoto(updatedPhoto)
        } else {
            deletePhoto(updatedPhoto)
        }
    }
    
    private func savePhoto(_ photo: PhotoPresentable) {
        
        StorageManager.shared.savePhoto(photo) { (result) in
            print(result)
        }
    }
    
    private func deletePhoto(_ photo: PhotoPresentable) {
        
        StorageManager.shared.deletePhoto(photo) { (result) in
            print(result)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
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
