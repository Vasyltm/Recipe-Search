//
//  File.swift
//  Recipe Search
//
//  Created by Vasyl Travlinskyy on 10.09.2020.
//  Copyright © 2020 Vasyl Travlinskyy. All rights reserved.
//

import Foundation
import UIKit



extension RecipeDetails: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Ingradients"
    }
}


extension RecipeDetails: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.recipe.ingredients?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngradientsCell", for: indexPath) as! IngradientsCell
        
        cell.labelIngradient.text = viewModel?.recipe.ingredients?[indexPath.row]
        
        return cell
    }
    
    
}
