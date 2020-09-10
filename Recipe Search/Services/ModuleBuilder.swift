//
//  File.swift
//  Recipe Search
//
//  Created by Vasyl Travlinskyy on 08.09.2020.
//  Copyright © 2020 Vasyl Travlinskyy. All rights reserved.
//

import Foundation
import UIKit

struct ModuleBuilder {
    
    
    static func buildRecipeDetails(recipe: Recipe) -> UIViewController {
        let controller = RecipeDetails()
        let viewModel = RecipeDetailsViewModel(reciep: recipe)
        controller.viewModel = viewModel
        return controller
    }
    
    
}
