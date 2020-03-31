//
//  UIView+Extension.swift
//  FlickrDemo
//
//  Created by Charles Hsieh on 2020/3/31.
//  Copyright © 2020 Charles Hsieh. All rights reserved.
//

import UIKit

// MARK: - Methods
extension UIView {
    
    @discardableResult
    func anchor(
        top: NSLayoutYAxisAnchor? = nil,
        leading: NSLayoutXAxisAnchor? = nil,
        bottom: NSLayoutYAxisAnchor? = nil,
        trailing: NSLayoutXAxisAnchor? = nil,
        padding: UIEdgeInsets,
        widthConstant: CGFloat = 0,
        heightConstant: CGFloat = 0) -> [NSLayoutConstraint] {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        var anchors = [NSLayoutConstraint]()
        
        if let top = top {
            anchors.append(topAnchor.constraint(equalTo: top, constant: padding.top))
        }
        
        if let leading = leading {
            anchors.append(leadingAnchor.constraint(equalTo: leading, constant: padding.left))
        }
        
        if let bottom = bottom {
            anchors.append(bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom))
        }
        
        if let trailing = trailing {
            anchors.append(trailingAnchor.constraint(equalTo: trailing, constant: -padding.right))
        }
        
        if widthConstant > 0 {
            anchors.append(widthAnchor.constraint(equalToConstant: widthConstant))
        }
        
        if heightConstant > 0 {
            anchors.append(heightAnchor.constraint(equalToConstant: heightConstant))
        }
        
        anchors.forEach { $0.isActive = true }
        
        return anchors
    }
    
    func anchorCenterSuperview() {
        
        anchorCenterXToSuperview()
        anchorCenterYToSuperview()
    }
    
    func anchorCenterXToSuperview(constant: CGFloat = 0) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let anchor = superview?.centerXAnchor {
            centerXAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        }
    }
    
    func anchorCenterYToSuperview(constant: CGFloat = 0) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let anchor = superview?.centerYAnchor {
            centerYAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        }
    }
}
