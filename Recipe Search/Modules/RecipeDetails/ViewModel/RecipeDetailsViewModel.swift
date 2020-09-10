//
//  File.swift
//  Recipe Search
//
//  Created by Vasyl Travlinskyy on 09.09.2020.
//  Copyright © 2020 Vasyl Travlinskyy. All rights reserved.
//

import Foundation


class RecipeDetailsViewModel {
    
    var recipe: Recipe
    var updateIngradients: (()->()) = {}
    
    func getIngradients(recipeId: String) {
        ServerHandler.request(.getIngradients, searchFor: recipeId) { [weak self] response in
            guard let self = self else { return }
            switch response {
                case .failure(let error): print(error.localizedDescription)
                case .success(let data):
                    let i = data["recipe"] as? [String: Any] ?? [:]
                    let ingradients = i["ingredients"] as? [String] ?? [""]
                    self.recipe.ingredients = ingradients
                    self.updateIngradients()
            }
        }
    }
    
    init(recipe: Recipe) {
        self.recipe = recipe
    }
    
   
    
    
}
