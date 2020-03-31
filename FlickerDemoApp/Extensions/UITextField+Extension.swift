//
//  UITextField+Extension.swift
//  FlickerDemoApp
//
//  Created by Charles Hsieh on 2020/3/31.
//  Copyright © 2020 Charles Hsieh. All rights reserved.
//

import UIKit

extension UITextField {
    
    var isEmpty: Bool {
        guard let text = text else {
            return true
        }
        return text.trimmingCharacters(in: .whitespaces) == ""
    }
}
