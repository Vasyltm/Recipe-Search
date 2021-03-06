//
//  RecipePageOptions.swift
//  Recipe Search
//
//  Created by Vasyl Travlinskyy on 08.09.2020.
//  Copyright © 2020 Vasyl Travlinskyy. All rights reserved.
//

import Foundation



struct SearchOption {
    var taskId = 0
    var text = ""
    var page = 1
    var numberOfRecipesForCall = 0
    var numberOfRecipesFromLastCall = 0
    let maxRecipesForCall = 30
    var numbersOfAnimatedCells: Int {
        return 20
    }
    var isLoadCompleted = false
    var delayLoad = false
    var isLoadingMoreEnabled: Bool {
        numberOfRecipesForCall == maxRecipesForCall
    }
}
 
