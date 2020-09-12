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
    
    var updateTableView: () -> () = {  }
    var updateTableViewCellAmount: (Int) -> () = { _ in }
    var updateTableViewByIndex: (Int) -> () = { _ in  }
    var showError: ((Errors)->()) = {_ in }
    var recipe = [Recipe]()
    var isLoadEnabled = true
    var isErrorEnabled = true
    var search = SearchOption()
    var isLoadingMoreEnabled: Bool {
        self.search.numberOfRecipes == self.search.maxRecipesForCall
    }
    
    
    func getRecipes(_ action: ChooseAction, searchFor: String = "", onPage: String = "1") {
        
        guard isLoadEnabledWithOptions(action, text: searchFor) else { isLoadEnabled = true; return }
   
        ServerHandler.request(action, searchFor: search.text, onPage: String(search.page)) { [weak self] response in
            
            guard let self = self else { return }
            switch response {
                case .failure(let error):
                    print(error.localizedDescription)
                    self.showError(.serverConectionError)
                    self.isLoadEnabled = true
                    self.recipe = []
                    self.updateTableView()
                case .success(let data):
                    if action != .loadMoreRecipes{
                        self.recipe = []  /// delete animated tableView cells
                    }
                    
                    #warning("check if need both numberOfRecipes and numbersOfCells")
                    self.search.numberOfRecipes = data["count"] as? Int ?? 0
                    self.search.numbersOfCells = self.search.numberOfRecipes
                    if self.search.numbersOfCells > 6 { self.updateTableViewCellAmount(self.search.numbersOfCells) }
                    
                    let recipeData = data["recipes"] as? [[String: Any]] ?? []
                    
                    let imageQueue = DispatchQueue(label: "my")
                    
                    loop: for (index, value) in recipeData.enumerated(){
//                        if !(self.search.shouldReloadSearch ?? false) {
//                            self.search.shouldReloadSearch = false
//                            self.dispatchGroup.suspend()
//                            self.recipe = []
//                            self.search.numbersOfCells = self.search.numbersOfAnimatedCells
//                            self.updateTableView()
//                            self.isLoadEnabled = true
//                            print("--------------")
//                            //self.updateTableViewCellAmount(2)
//                            break loop
//                        }
                        let id = value["recipe_id"] as? String ?? ""
                        let imageStringURL = value["image_url"] as? String ?? ""
                        let sourceURL = value["source_url"] as? String ?? ""
                        let title = value["title"] as? String ?? ""
                        var recipe = Recipe(id: id, image_url: imageStringURL, source_url: sourceURL, title: title)
                        
                        imageQueue.async(group: self.dispatchGroup) {
                            guard let imagrURL = URL(string: imageStringURL)  else {self.isLoadEnabled = true;  return }
                            do {
                                let data = try Data(contentsOf: imagrURL)
                                if  recipe.image == nil {
                                    recipe.image = data
                                    self.recipe.append(recipe)
                                    print("before")
                                    if index <  self.search.numbersOfAnimatedCells && action == .getRecipeOnSearchButton {
                                        
                                        
                                        
//                                        if self.search.numberOfRecipes < self.search.numbersOfAnimatedCells {
//                                            if index == self.search.numberOfRecipes - 1 {
//                                                self.search.isAnimatedCellsEnabled = false
//                                                self.updateTableView()
//                                            }
//                                        }
                                        self.updateTableViewByIndex(index)
                                    }
                                }
                            } catch {
                                print("error loading image")
                            }
                        }
                    }
                    
                    self.dispatchGroup.notify(queue: .global()) {
                        if self.recipe.count == 0  && self.isErrorEnabled { self.showError(.nothingFound); self.isErrorEnabled = false }
                        if action == .getRecipeOnSearchButton || self.search.numberOfRecipes < self.search.numbersOfAnimatedCells {
                            self.search.isAnimatedCellsEnabled = false
                        }
                        if action == .getRecipeOnSearchButton { self.search.numbersOfCells = self.search.numbersOfAnimatedCells }
                        
                        self.isLoadEnabled = true
                }
            }
        }
    }
    
    
    private func isLoadEnabledWithOptions(_ action: ChooseAction, text: String) -> Bool {
        
        if text.count < 3 && action == .getRecipeOnSearchButton   { showError(.searchInputTooShort); recipe = []; updateTableView(); return false}
        
        isLoadEnabled = false
        
        switch action {
            case  .getRecipeOnSearchButton:
                self.recipe = []
                search.text = text
                search.page = 1
                let recipes = Recipe(id: "", image_url: "", source_url: "", title: "loadView")
                for _ in 0..<self.search.numbersOfAnimatedCells {
                    recipe.append(recipes)
                }
                self.search.isAnimatedCellsEnabled = true
                updateTableView()
                return true
            case let action where action == .loadMoreRecipes && self.search.numberOfRecipes == self.search.maxRecipesForCall:
                search.page += 1
                self.search.isAnimatedCellsEnabled = false
                return true
            default: return false
        }
        
    }
    
    
    
}
