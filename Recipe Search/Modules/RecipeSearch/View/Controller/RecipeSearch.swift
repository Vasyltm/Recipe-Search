//
//  RecipeSerch.swift
//  Recipe Search
//
//  Created by Vasyl Travlinskyy on 08.09.2020.
//  Copyright © 2020 Vasyl Travlinskyy. All rights reserved.
//

import UIKit

extension UITableView {
    var dataHasChanged: Bool {
        guard let dataSource = dataSource else { return false }
        let sections = dataSource.numberOfSections?(in: self) ?? 0
        if numberOfSections != sections {
            return true
        }
        for section in 0..<sections {
            if numberOfRows(inSection: section) != dataSource.tableView(self, numberOfRowsInSection: section) {
                return true
            }
        }
        return false
    }
}

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
        updateTableViewByIndex()
        searchBar.hideBorder()
        updateTableView()
        updateTableViewCells()
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
    
    
    func updateTableViewCells() {
        viewModel.updateTableViewCellAmount = { [weak self] numberOfCells in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if self.tableViewRecipeBottomspinner.isAnimating {
                    self.tableViewRecipeBottomspinner.stopAnimating()
                }
                var indexPath = [IndexPath(row: numberOfCells, section: 0)]
                for i in numberOfCells...self.viewModel.search.numberOfRecipesForCall + numberOfCells - 1 {
                    indexPath.append(IndexPath(row: i, section: 0))
                }
                print(indexPath)
                self.tableViewRecipe.beginUpdates()
                self.tableViewRecipe.insertRows(at: indexPath, with: .middle)
                self.tableViewRecipe.endUpdates()
                
            }
        }
    }
    
    
    func updateTableViewByIndex() {
        viewModel.updateTableViewByIndex = { [weak self] index in
            DispatchQueue.main.async {
                
                self?.tableViewRecipe.beginUpdates()
                self?.tableViewRecipe.reloadRows(at: [IndexPath(row: index, section: 0)], with: .left)
                self?.tableViewRecipe.endUpdates()
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

