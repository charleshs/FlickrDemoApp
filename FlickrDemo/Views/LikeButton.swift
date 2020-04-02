//
//  LikeButton.swift
//  FlickrDemo
//
//  Created by Charles Hsieh on 2020/4/1.
//  Copyright © 2020 Charles Hsieh. All rights reserved.
//

import UIKit

class LikeButton: UIButton {
    
    override var isSelected: Bool {
        didSet {
            tintColor = isSelected ? .clear : .white
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    private func setupView() {
        
        isSelected = false
        setImage(ImageAsset.icon_heart_stroke.image()?.withRenderingMode(.alwaysTemplate), for: .normal)
        setImage(ImageAsset.icon_heart_fill.image()?.withRenderingMode(.alwaysOriginal), for: .selected)
    }
}
