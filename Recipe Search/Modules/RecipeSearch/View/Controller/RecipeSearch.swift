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
    
    var viewModel = RecipeSearchViewModel()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        tableViewRecipe.register(RecipeCell.self, forCellReuseIdentifier: "Cell")
        searchBar.hideBorder()
        updateTableView()
        showError()
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        searchBar.becomeFirstResponder()
        navigationController?.navigationBar.isHidden = true
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        navigationController?.navigationBar.isHidden = false
    }
    
    
    func showError() {
        viewModel.showError = { [weak self] error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.errorBlock.isHidden = false
                self.errorBlock.numberOfLines = .max
                self.errorBlock.lineBreakMode = .byWordWrapping
                self.errorBlock.layer.zPosition = 10
                self.errorBlock.text = error.description
            }
        }
    }
    
    
    func updateTableView() {
        viewModel.updateTableView = { [weak self] in
            DispatchQueue.main.async {
                self?.tableViewRecipe.layer.opacity = 0
                UIView.animate(withDuration: 0.3) {
                    self?.tableViewRecipe.reloadData()
                    
                    
                    self?.tableViewRecipe.layer.opacity = 1
                }
            }
        }
    }
    
    
}

