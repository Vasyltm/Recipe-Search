//
//  RecipeSerch.swift
//  Recipe Search
//
//  Created by Vasyl Travlinskyy on 08.09.2020.
//  Copyright © 2020 Vasyl Travlinskyy. All rights reserved.
//

import UIKit

class RecipeSearch: UIViewController  {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableViewRecipe: UITableView!
    @IBOutlet weak var errorBlock: UILabel!
    let tableViewRecipeBottomspinner = UIActivityIndicatorView(style: .gray)
    var viewModel = RecipeSearchViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewRecipe.register(RecipeCell.self, forCellReuseIdentifier: "Cell")
        setErrorBlock()
        searchBar.hideBorder()
        updateTableView()
        showError()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        searchBar.becomeFirstResponder()
        navigationController?.navigationBar.isHidden = true
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        navigationController?.navigationBar.isHidden = false
    }
    
    
    func updateTableView() {
        viewModel.updateTableView = { [weak self] in
            DispatchQueue.main.async {
                if self?.tableViewRecipeBottomspinner.isAnimating ?? true {
                    self?.tableViewRecipeBottomspinner.stopAnimating()
                }
                self?.tableViewRecipe.layer.opacity = 0
                self?.tableViewRecipe.reloadData()
                UIView.animate(withDuration: 0.5) {
                    self?.tableViewRecipe.layer.opacity = 1
                }
            }
        }
    }
    
    
    func showError() {
        viewModel.showError = { [weak self] error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.errorBlock.fadeIn()
                self.viewModel.isErrorEnabled = true
                self.errorBlock.text = error.description
            }
        }
    }
    
    
    func setErrorBlock() {
        errorBlock.numberOfLines = .max
        errorBlock.isHidden = true
        errorBlock.layer.zPosition = 10
    }
    
    
}

