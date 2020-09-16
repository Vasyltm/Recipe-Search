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
//        addTableViewCells()
//        deleteTableViewCells()
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
//                self?.tableViewRecipe.layer.opacity = 0
                self?.tableViewRecipe.reloadData()
//                UIView.animate(withDuration: 0.5) {
//                    self?.tableViewRecipe.layer.opacity = 1
//                }
            }
        }
    }
    
    
//    func addTableViewCells() {
//        viewModel.addTableViewCells = { [weak self] from, to in
//            guard let self = self else { return }
//            print("error in add tableview")
//            DispatchQueue.main.async {
//                if self.tableViewRecipeBottomspinner.isAnimating {
//                    self.tableViewRecipeBottomspinner.stopAnimating()
//                }
//                print("Range \(from)...\(to  - 1)")
//                var indexPath = [IndexPath(row: from, section: 0)]
//                for i in from + 1..<to {
//                    indexPath.append(IndexPath(row: i, section: 0))
//                }
//                print("indexPath to add cells \(indexPath)")
//                print("I want to see tows in add: \(self.tableViewRecipe.numberOfRows(inSection: 0)) while recipe is \(self.viewModel.recipe.count) and other \(self.viewModel.search.numberOfRecipesForCall)")
//                guard self.tableViewRecipe.numberOfRows(inSection: 0) != self.viewModel.recipe.count else { print("error in add catched"); return }
//                guard self.tableViewRecipe.numberOfRows(inSection: 0) == self.viewModel.search.numbersOfAnimatedCells else { print("error2 in add catched"); return }
//                self.tableViewRecipe.beginUpdates()
//                self.tableViewRecipe.insertRows(at: indexPath, with: .middle)
//                self.tableViewRecipe.endUpdates()
//                self.viewModel.isUpdateAvailable = true
//            }
//        }
//    }
    
    
//    func deleteTableViewCells() {
//        viewModel.deleteTableViewCells = { [weak self] from, to in
//            guard let self = self else { return }
//            DispatchQueue.main.async {
//                var indexPath = [IndexPath(row: from, section: 0)]
//                for i in from + 1..<to {
//                    indexPath.append(IndexPath(row: i, section: 0))
//                }
//                print("error in delete tableview")
//                print("I want to see tows in delete: \(self.tableViewRecipe.numberOfRows(inSection: 0)) while recipe is \(self.viewModel.recipe.count)")
//                print("indexPath to delete cells \(indexPath)")
//                self.tableViewRecipe.beginUpdates()
//                self.tableViewRecipe.deleteRows(at: indexPath, with: .middle)
//                self.tableViewRecipe.endUpdates()
//            }
//        }
//    }
    
    
    func updateTableViewByIndex() {
        viewModel.updateTableViewByIndex = { [weak self] index in
            DispatchQueue.main.async {
                // check race condition
                guard self?.tableViewRecipe.numberOfRows(inSection: 0) == self?.viewModel.recipe.count else { print ("error cathed in updateTableViewByIndex");return }
                self?.tableViewRecipe.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
            }
        }
    }
    
    
    func showError() {
        viewModel.showError = { [weak self] error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.errorBlock.fadeIn()
               // self.viewModel.isErrorEnabled = true
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

