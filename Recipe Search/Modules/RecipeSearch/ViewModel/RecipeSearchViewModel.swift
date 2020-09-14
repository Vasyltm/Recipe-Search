//
//  RecipeSearchViewModel.swift
//  Recipe Search
//
//  Created by Vasyl Travlinskyy on 08.09.2020.
//  Copyright © 2020 Vasyl Travlinskyy. All rights reserved.
//

import Foundation



final class RecipeSearchViewModel {
    
    let dispatchGroup = DispatchGroup()
    var serverHandler = ServerHandler()
    var updateTableView: () -> () = {  }
    
    //MARK: add 1 property to share cell from to
    var updateTableViewCellAmount: (Int) -> () = { _ in }
    
    
    var updateTableViewByIndex: (Int) -> () = { _ in  }
    var showError: ((Errors)->()) = {_ in }
    var recipe = [Recipe]()
    var isErrorEnabled = true
    var search = SearchOption()
    var isLoadingMoreEnabled: Bool {
        self.search.numberOfRecipesTotal == self.search.maxRecipesForCall
    }
    
    
    func getRecipes(_ action: ChooseAction, searchFor: String = "", onPage: String = "1") {
        
        if serverHandler.task?.state != nil && action == .getRecipeOnSearchButton {
            serverHandler.task?.cancel()
        }
        self.search.taskId += 1
        let imageQueue = DispatchQueue(label: "\(self.search.taskId)")
        
        guard isLoadEnabledWithOptions(action, text: searchFor) else { search.isLoadMoreEnabled = true; return }
        
        serverHandler.request(action, searchFor: search.text, onPage: String(search.page)) { [weak self] response in
            guard let self = self else { return }
            switch response {
                case .failure(let error):
                    if !error.localizedDescription.contains("cancelled") {
                        print(error.localizedDescription)
                        self.showError(.serverConectionError)
                        self.search.isLoadMoreEnabled = true
                        self.recipe = []
                        self.updateTableView()
                }
                
                case .success(let data):
                    if self.search.taskId == 254 { self.search.taskId = 1 }
                    self.search.numberOfRecipesForCall = data["count"] as? Int ?? 0
                    guard self.search.numberOfRecipesForCall > 0 else {
                        self.updateTableView()
                        self.recipe = []
                        self.showError(.nothingFound)
                        return
                    }
                    self.search.numberOfRecipesTotal = data["count"] as? Int ?? 0
                    let recipeData = data["recipes"] as? [[String: Any]] ?? []
                    
                    
                    print("numberOfRecipesForCall \(self.search.numberOfRecipesForCall)")
                    if  self.recipe.count < self.search.numberOfRecipesTotal {
                        self.recipe = []  /// delete animated tableView cells
                        print(">>>>>>>>\(self.search.numbersOfAnimatedCells)..\(self.search.numberOfRecipesForCall)")
                        for _  in recipeData {
                            let recipe = Recipe(id: "", image_url: "", source_url: "", title: "")
                            self.recipe.append(recipe)
                        }
                        switch action {
                            case .getRecipeOnSearchButton: self.updateTableViewCellAmount(self.search.numbersOfAnimatedCells)
                            case .loadMoreRecipes: self.updateTableViewCellAmount(self.search.numberOfRecipesTotal)
                            default: return
                        }
                        
                    }
                    
                    
                    
                    
                    
                    
                    loop: for (index, value) in recipeData.enumerated(){
                        
                        let id = value["recipe_id"] as? String ?? ""
                        let imageStringURL = value["image_url"] as? String ?? ""
                        let sourceURL = value["source_url"] as? String ?? ""
                        let title = value["title"] as? String ?? ""
                        var recipe = Recipe(id: id, image_url: imageStringURL, source_url: sourceURL, title: title)
                        
                        imageQueue.async(group: self.dispatchGroup) {
                            
                            guard String(self.search.taskId) == imageQueue.label, let imagrURL = URL(string: imageStringURL), self.recipe.indices.contains(index)  else { return }
                            print(imageQueue.label)
                            do {
                                let data = try Data(contentsOf: imagrURL)
                                if  recipe.image == nil {
                                    recipe.image = data
                                    if index <  self.recipe.count {
                                        
                                        print("number of recipes: \(self.recipe.count )  and index is \(index)")
                                        self.recipe[index] = recipe
                                        self.updateTableViewByIndex(index)
                                    }
                                }
                            } catch {
                                print("error loading image")
                            }
                        }
                    }
                    
                    self.dispatchGroup.notify(queue: .global()) {
                        if self.search.numberOfRecipesForCall < self.search.numbersOfAnimatedCells {
                         //   if index == self.search.numberOfRecipes - 1 {
                         //   self.recipe = []
                                self.updateTableView()
                          //  }
                        }
                        self.search.isLoadMoreEnabled = true
                        //                        if self.recipe.count == 0  && self.isErrorEnabled {
                        //                            self.showError(.nothingFound);
                        //                            self.search.numbersOfCells = 0;
                        //                            self.updateTableView();
                        //                            self.isErrorEnabled = false
                        //
                        //                        }
                        //                        if action == .getRecipeOnSearchButton || self.search.numberOfRecipes < self.search.numbersOfAnimatedCells {
                        //                            self.search.isAnimatedCellsEnabled = false
                        //                        }
                        //
                        //
                        //                        self.isLoadEnabled = true
                }
            }
        }
    }
    
    
    private func isLoadEnabledWithOptions(_ action: ChooseAction, text: String) -> Bool {
     
        
        switch action {
            case  .getRecipeOnSearchButton:
                self.recipe = []
                search.text = text
                search.page = 1
                let recipes = Recipe(id: "", image_url: "", source_url: "", title: "loadView")
                for _ in 0..<self.search.numbersOfAnimatedCells {
                    recipe.append(recipes)
                }
                updateTableView()
                return true
            case let action where action == .loadMoreRecipes && self.search.numberOfRecipesForCall == self.search.maxRecipesForCall:
                search.page += 1
                return true
            default: return false
        }
        
    }
    
    
    
}
