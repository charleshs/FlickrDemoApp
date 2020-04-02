//
//  PhotoCollectionViewCell.swift
//  FlickrDemo
//
//  Created by Charles Hsieh on 2020/4/1.
//  Copyright © 2020 Charles Hsieh. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var likeButton: LikeButton!
    
    var likeActionHandler: ((PhotoCollectionViewCell) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(title: String?, image: String?,
                       likeAction: @escaping (PhotoCollectionViewCell) -> Void = { _ in }) {
        
        titleLabel.text = title
        photoImageView.loadImage(image)
        self.likeActionHandler = likeAction
    }
    @IBAction func didTapLikeButton(_ sender: Any) {
        
        likeActionHandler?(self)
    }
}
