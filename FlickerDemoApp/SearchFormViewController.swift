//
//  SearchFormViewController.swift
//  FlickerDemoApp
//
//  Created by Charles Hsieh on 2020/3/31.
//  Copyright © 2020 Charles Hsieh. All rights reserved.
//

import UIKit

class SearchFormViewController: UIViewController {
    
    lazy var contentOfSearchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "欲搜尋內容"
        return textField
    }()
    
    lazy var numberOfItemsPerPageTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "每頁呈現數量"
        return textField
    }()
    
    lazy var searchButton: UIButton = {
        let button = UIButton()
        button.setTitle("搜尋", for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    private func setupViews() {
        
    }
}

