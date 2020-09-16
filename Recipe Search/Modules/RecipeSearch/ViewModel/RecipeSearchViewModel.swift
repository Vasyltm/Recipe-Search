//
//  RecipeSearchViewModel.swift
//  Recipe Search
//
//  Created by Vasyl Travlinskyy on 08.09.2020.
//  Copyright © 2020 Vasyl Travlinskyy. All rights reserved.
//

import Foundation



final class RecipeSearchViewModel: URLSessionDataTask   {
    
    
    var operation: BlockOperation?
    
    let queue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    let dispatchGroup = DispatchGroup()
    var serverHandler = ServerHandler()
    var updateTableView: () -> () = {  }
    var updateTableViewByIndex: (Int) -> () = { _ in  }
    var showError: ((Errors)->()) = {_ in }
    var recipe = [Recipe]()
    var search = SearchOption()
    
    func getRecipes(_ action: ChooseAction, searchFor: String = "", onPage: String = "1") {
        
        guard self.isLoadEnabledWithOptions(action, searchText: searchFor) else {
            self.search.numberOfRecipesFromLastCall = 0
            self.search.isLoadCompleted = true
            return
        }
        
        serverHandler.request(action, searchFor: search.text, onPage: String(search.page)) { [weak self] response in
            guard let self = self else { return }
            switch response {
                case .failure(let error):
                    if !error.localizedDescription.contains("cancelled") {
                        //print(error.localizedDescription)
                        self.showError(.serverConectionError)
                        self.recipe = []
                        self.updateTableView()
                    }
                    self.search.isLoadCompleted = true
                
                case .success(let data):
                    
                    self.operation?.cancel()
                    self.queue.cancelAllOperations()
                    self.search.taskId += 1
                    let imageQueue = DispatchQueue(label: "\(self.search.taskId)")
                    
                    let operation = BlockOperation {
                        
                        if self.search.taskId == Int8.max { self.search.taskId = 1 }
                        self.search.numberOfRecipesForCall = data["count"] as? Int ?? 0
                        
                        guard self.search.numberOfRecipesForCall > 0  else {
                            if action == .getRecipeOnSearchButton {
                                self.recipe = []
                                self.updateTableView()
                                self.showError(.nothingFound)
                            }
                            return
                        }
                        
                        guard searchFor.count >= 1 else {
                            self.recipe = []
                            self.updateTableView()
                            return
                        }
                        
                        let recipeData = data["recipes"] as? [[String: Any]] ?? []
                        
                        if  self.search.numbersOfAnimatedCells < self.search.numberOfRecipesForCall || action == .loadMoreRecipes {
                            switch action {
                                case .getRecipeOnSearchButton:
                                    self.recipe = []
                                    self.updateRecipe(recipeData.count)
                                    self.updateTableView()
                                case .loadMoreRecipes:
                                    self.updateRecipe(recipeData.count)
                                    self.updateTableView()
                                default: return
                            }
                        } else if self.search.numbersOfAnimatedCells > self.search.numberOfRecipesForCall && action == .getRecipeOnSearchButton {
                            self.recipe = []
                            self.updateRecipe(recipeData.count)
                            self.updateTableView()
                        }
                        
                        loop: for (index, value) in recipeData.enumerated(){
                            imageQueue.async(group: self.dispatchGroup) {
                                let id = value["recipe_id"] as? String ?? ""
                                let imageStringURL = value["image_url"] as? String ?? ""
                                let sourceURL = value["source_url"] as? String ?? ""
                                let title = value["title"] as? String ?? ""
      
                                guard String(self.search.taskId) == imageQueue.label, let imagrURL = URL(string: imageStringURL), self.recipe.indices.contains(index)  else { return }
                                var recipe = Recipe(id: id, image_url: imageStringURL, source_url: sourceURL, title: title)
                                do {
                                    let data = try Data(contentsOf: imagrURL)
                                    if  recipe.image == nil {
                                        recipe.image = data
                                        if index <  self.recipe.count {
                                            switch action {
                                                case .getRecipeOnSearchButton:
                                                    self.recipe[index] = recipe
                                                    self.updateTableViewByIndex(index)
                                                case .loadMoreRecipes:
                                                    self.recipe[index + self.search.numberOfRecipesFromLastCall] = recipe
                                                    self.updateTableViewByIndex(index  + self.search.numberOfRecipesFromLastCall)
                                                default: return
                                            }
                                        }
                                    }
                                } catch {
                                    print("error loading image")
                                }
                            }
                        }
                        
                        self.dispatchGroup.notify(queue: .global()) {
                            if String(self.search.taskId) == imageQueue.label {
                                self.search.numberOfRecipesFromLastCall += self.search.numberOfRecipesForCall
                                self.search.isLoadCompleted = true
                            }
                        }
                    }
                    self.operation = operation
                    self.queue.addOperation(self.operation!)
            }
        }
    }

    
    private func isLoadEnabledWithOptions(_ action: ChooseAction, searchText: String) -> Bool {
        switch action {
            case  .getRecipeOnSearchButton:
                if serverHandler.task?.state != nil {
                    serverHandler.task?.cancel()
                }
                self.recipe = []
                self.search.numberOfRecipesFromLastCall = 0
                search.text = searchText
                search.page = 1
                updateRecipe(search.numbersOfAnimatedCells)
                updateTableView()
                self.search.isLoadCompleted = false
                return true
            case let action where action == .loadMoreRecipes && self.search.numberOfRecipesForCall == self.search.maxRecipesForCall:
                search.page += 1
                self.search.isLoadCompleted = false
                return true
            default: return false
        }
    }
    
    
    private func updateRecipe(_ rangeEnd: Int) {
        for _  in 0..<rangeEnd {
            let recipe = Recipe(id: "", image_url: "", source_url: "", title: "loadView")
            self.recipe.append(recipe)
        }
    }
    
}
