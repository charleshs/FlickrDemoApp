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
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var photos: Photos? {
        didSet {
            guard photos != nil else { return }
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadData()
            }
        }
    }
    
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
}

extension SearchResultViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}

extension SearchResultViewController: UICollectionViewDelegateFlowLayout {
    
}
