//
//  CellRegistrator.swift
//  FlickrDemo
//
//  Created by Charles Hsieh on 2020/4/1.
//  Copyright © 2020 Charles Hsieh. All rights reserved.
//

import UIKit

protocol CellRegistrator: AnyObject {
    
    static var nib: UINib { get }
    static var identifier: String { get }
}

extension CellRegistrator {
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: CellRegistrator { }

extension UITableViewHeaderFooterView: CellRegistrator { }

extension UICollectionReusableView: CellRegistrator { }

extension UICollectionView {
    
    func csRegisterCell<T: UICollectionViewCell>(classType name: T.Type) {
        
        register(T.self, forCellWithReuseIdentifier: T.identifier)
    }
    
    func csRegisterNibCell<T: UICollectionViewCell>(nibClassType name: T.Type) {
        
        register(T.nib, forCellWithReuseIdentifier: T.identifier)
    }
    
    func csRegisterReusableView<T: UICollectionReusableView>(classType name: T.Type, of kind: String) {
        
        register(T.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: T.identifier)
    }
    
    func csRegisterNibReusableView<T: UICollectionReusableView>(nibClassType name: T.Type, of kind: String) {
        
        register(T.nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: T.identifier)
    }
}
