//
//  Extension.swift
//  Recipe Search
//
//  Created by Vasyl Travlinskyy on 10.09.2020.
//  Copyright © 2020 Vasyl Travlinskyy. All rights reserved.
//

import Foundation
import UIKit


extension RecipeSearch: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        errorBlock.isHidden = true
        viewModel.getRecipes(.getRecipeDynamic, searchFor: searchText)
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        errorBlock.isHidden = true
        viewModel.getRecipes(.getRecipeOnSearchButton, searchFor: searchBar.text ?? "")
        searchBar.resignFirstResponder()
    }

        
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if #available(iOS 13.0, *) {
            let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
            sceneDelegate?.window?.rootViewController = Main()
        } else {
            appDelegate.window?.rootViewController =  Main()
        }
    }
}



extension RecipeSearch: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  viewModel.recipe.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RecipeCell
        
        guard viewModel.recipe.count != 0 else {
            return cell
        }
        
        cell.recipeImage.layer.backgroundColor = Color.backgroundCG
        cell.recipeTitle.layer.backgroundColor = Color.backgroundCG
        
        cell.recipeImage.image = nil
        
        cell.recipeTitle.text = ""
        
        
        
        if viewModel.recipe[indexPath.row].title == "loadView" || cell.recipeTitle.text == "loadView" {
         
            UIView.animate(withDuration: 1.4, delay: 0.0, options:[UIView.AnimationOptions.repeat, UIView.AnimationOptions.autoreverse], animations: {
                cell.recipeImage.layer.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
                cell.recipeImage.layer.backgroundColor =  #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            }, completion: nil)
            
            UIView.animate(withDuration: 1.4, delay: 0.0, options:[.repeat, UIView.AnimationOptions.autoreverse], animations: {
                cell.recipeTitle.layer.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
                cell.recipeTitle.layer.backgroundColor =  #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            }, completion: nil)
            
            return cell
            
        }
        
        cell.recipeTitle.text = viewModel.recipe[indexPath.row].title
        
        let data = viewModel.recipe[indexPath.row].image
        cell.recipeImage.image = data != nil ? UIImage(data: data!) : UIImage(named: "cook")
        
        return cell
    }
    
}


extension RecipeSearch: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.showDetailViewController(UINavigationController(rootViewController:ModuleBuilder.buildRecipeDetails(recipe:  viewModel.recipe[indexPath.row])), sender: nil)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if tableViewRecipe.contentOffset.y >= (tableViewRecipe.contentSize.height - (tableViewRecipe.frame.size.height * 1.5)) {
            if viewModel.isLoadEnabled {
                errorBlock.isHidden = true
                viewModel.getRecipes(.loadMoreRecipes, searchFor: viewModel.search.text)
            }
        }
    }
    
}



