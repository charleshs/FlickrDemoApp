//
//  Storyboarded.swift
//  FlickrDemo
//
//  Created by Charles Hsieh on 2020/3/31.
//  Copyright © 2020 Charles Hsieh. All rights reserved.
//

import UIKit

protocol Storyboarded {
    
    static var storyboard: UIStoryboard { get }
    
    static func instantiate() -> Self
}

extension Storyboarded where Self: UIViewController {
    
    static func instantiate() -> Self {
        
        let viewController = storyboard.instantiateViewController(withIdentifier: String(describing: Self.self))
        
        guard let downCastedVC = viewController as? Self else {
            fatalError("Fail to instantiate: \(String(describing: Self.self))")
        }
        return downCastedVC
    }
}
