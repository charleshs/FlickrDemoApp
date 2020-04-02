//
//  SearchFormViewController.swift
//  FlickrDemo
//
//  Created by Charles Hsieh on 2020/3/31.
//  Copyright © 2020 Charles Hsieh. All rights reserved.
//

import UIKit

class SearchFormViewController: UIViewController {
    
    lazy var contentOfSearchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "欲搜尋內容"
        textField.borderStyle = .roundedRect
        textField.addTarget(self, action: #selector(textFieldOnEditingChanged(_:)), for: .editingChanged)
        return textField
    }()
    
    lazy var numberOfItemsPerPageTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "每頁呈現數量"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        textField.addTarget(self, action: #selector(textFieldOnEditingChanged(_:)), for: .editingChanged)
        return textField
    }()
    
    lazy var searchButton: UIButton = {
        let button = DeactivatableButton()
        button.setTitle("搜尋", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(search(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var vStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            self.contentOfSearchTextField,
            self.numberOfItemsPerPageTextField,
            self.searchButton
        ])
        stack.axis = .vertical
        stack.spacing = 16
        stack.distribution = .fillEqually
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        checkTextFieldsInput()
    }
    
    @objc func search(_ sender: UIButton) {
        
        guard
            let searchContent = contentOfSearchTextField.text?.trimmingCharacters(in: .whitespaces),
            let itemsPerPage = numberOfItemsPerPageTextField.text?.trimmingCharacters(in: .whitespaces)
        else {
            return
        }
        let photoSearchManager = PhotoSearchManager(searchText: searchContent, itemsPerPage: Int(itemsPerPage) ?? 0)
        showSearchResult(photoSearchManager)
    }
    
    private func showSearchResult(_ provider: PhotoListProvider) {
        
        let searchResultVC = SearchResultViewController.instantiate()
        searchResultVC.photoListProvider = provider
        navigationController?.pushViewController(searchResultVC, animated: true)
    }
    
    @objc func textFieldOnEditingChanged(_ sender: UITextField) {
        
        checkTextFieldsInput()
    }
    
    private func checkTextFieldsInput() {
        
        searchButton.isEnabled = !(contentOfSearchTextField.isEmpty || numberOfItemsPerPageTextField.isEmpty)
    }
    
    private func setupViews() {
        
        view.addSubview(vStackView)
        vStackView.anchorCenterSuperview()
        vStackView.widthAnchor.constraint(equalToConstant: UIScreen.width - 40).isActive = true
        vStackView.heightAnchor.constraint(equalToConstant: 120).isActive = true
    }
}

