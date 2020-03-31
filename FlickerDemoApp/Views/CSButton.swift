//
//  CSButton.swift
//  FlickerDemoApp
//
//  Created by Charles Hsieh on 2020/3/31.
//  Copyright © 2020 Charles Hsieh. All rights reserved.
//

import UIKit

class CSButton: UIButton {
    
    override var isEnabled: Bool {
        didSet {
            updateBackgroundColor()
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            updateBackgroundColor()
        }
    }
    
    func updateBackgroundColor() {
        if isEnabled {
            backgroundColor = isHighlighted ? UIColor.cyan : UIColor.systemBlue
        } else {
            backgroundColor = UIColor.systemGray
        }
    }
}
