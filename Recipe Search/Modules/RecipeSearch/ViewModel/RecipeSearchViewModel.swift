//
//  RecipeSearchViewModel.swift
//  Recipe Search
//
//  Created by Vasyl Travlinskyy on 08.09.2020.
//  Copyright © 2020 Vasyl Travlinskyy. All rights reserved.
//

import Foundation



class RecipeSearchViewModel {
    
    let dispatchGroup = DispatchGroup()
    var workItem: DispatchWorkItem?
    var updateTableView: () -> () = {  }
    var showError: ((Errors)->()) = {_ in }
    var recipe = [Recipe]()
    var isLoadEnabled = true
    var search = SearchOption()
    
    
    func getRecipes(_ action: ChooseAction, searchFor: String = "", onPage: String = "1") {
        
        
        guard isLoadEnabled(action, text: searchFor) else { isLoadEnabled = true; return }
        
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
                        self.recipe = []
                    }
                    self.search.numberOfRecipes = data["count"] as? Int ?? 0
                    let recipes = data["recipes"] as? [[String: Any]] ?? []
                    for recipe in recipes {
                        let id = recipe["recipe_id"] as? String ?? ""
                        let imageStringURL = recipe["image_url"] as? String ?? ""
                        let sourceURL = recipe["source_url"] as? String ?? ""
                        let title = recipe["title"] as? String ?? ""
                        var recipe = Recipe(id: id, image_url: imageStringURL, source_url: sourceURL, title: title)
                        guard let imagrURL = URL(string: imageStringURL)  else {self.isLoadEnabled = true;  return }
                        self.workItem = DispatchWorkItem  { [weak self] in
                            guard let self = self else {return}
                            
                            self.dispatchGroup.enter()
                            do {
                                let data = try  Data(contentsOf: imagrURL)
                                if  recipe.image == nil {
                                    recipe.image = data
                                    self.recipe.insert(recipe, at: 0)
                                }
                            } catch {
                                print("error loading image")
                            }
                            self.dispatchGroup.leave()
                            
                            
                        }
                        
                        DispatchQueue.global().async(execute: self.workItem!)
                        
                        
                    }
                    
                    self.dispatchGroup.notify(queue: .global()) {
                        sleep(1)
                        self.updateTableView()
                        if self.recipe.count == 0 {  self.showError(.nothingFound) }
                        self.isLoadEnabled = true
                }
            }
        }
    }
    
    
    private func isLoadEnabled (_ action: ChooseAction, text: String) -> Bool {
        
        guard text.count >= 3 else {self.recipe = []; self.updateTableView(); return false}
      
        isLoadEnabled = false
        
        switch action {
            case let action where action == .getRecipeDynamic && text == "":
                self.recipe = []; updateTableView()
                return false
            case .getRecipeDynamic, .getRecipeOnSearchButton:
                self.recipe = []
                workItem?.cancel()
                search.text = text
                search.page = 1
                let recipes = Recipe(id: "", image_url: "", source_url: "", title: "loadView")
                for _ in 0...5 {
                    recipe.append(recipes)
                }
                self.updateTableView()
                return true
            case let action where action == .loadMoreRecipes && self.search.numberOfRecipes == self.search.maxRecipesForCall:
                search.page += 1
                return true
            default: return false
        }
        
        
    }
    
    
    
}
