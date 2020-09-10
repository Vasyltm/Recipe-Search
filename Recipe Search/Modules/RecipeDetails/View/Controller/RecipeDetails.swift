//
//  RecipeDetails.swift
//  Recipe Search
//
//  Created by Vasyl Travlinskyy on 09.09.2020.
//  Copyright © 2020 Vasyl Travlinskyy. All rights reserved.
//

import UIKit

class RecipeDetails: UIViewController {
    
    var viewModel: RecipeDetailsViewModel?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableViewIngradients: UITableView!
    @IBOutlet weak var buttonOpenInBrowser: UIButton!
    var shouldChangeSpliteVCStile: Bool?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView()
        
        tableViewIngradients.register(UINib.init(nibName: "IngradientsCell", bundle: nil), forCellReuseIdentifier: "IngradientsCell")
        
        getIngradients()
        updateIngradients()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if viewModel == nil {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            buttonOpenInBrowser.isHidden = true
            if UIScreen.main.bounds.width < UIScreen.main.bounds.height {
                appDelegate.splitViewController.preferredDisplayMode = .primaryOverlay
                shouldChangeSpliteVCStile = true
            } else {
                appDelegate.splitViewController.preferredDisplayMode = .automatic
            }
        } else {
            buttonOpenInBrowser.isHidden = false
        }
        if shouldChangeSpliteVCStile ?? false {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.splitViewController.preferredDisplayMode = .automatic
        }
    }
    
    
    func getIngradients() {
        if let v = viewModel {
            v.getIngradients(recipeId: (v.recipe.id))
        }
    }
    
    
    func updateIngradients() {
        viewModel?.updateIngradients = { [weak self] in
            guard  let self = self else { return }
            DispatchQueue.main.async {
                self.tableViewIngradients.reloadData()
            }
        }
    }
    
    
    @IBAction func openRecipeInWeb(_ sender: Any) {
        guard let url =  URL(string: (viewModel?.recipe.source_url)!) else { return }
        UIApplication.shared.open(url)
    }
    
    
    func setView() {
        
        title = viewModel?.recipe.title
        
        let data = viewModel?.recipe.image
        imageView.image  = data != nil ? UIImage(data: data!) : UIImage(named: "cook")
        
        imageView.layer.cornerRadius = 10
        
        tableViewIngradients.layer.cornerRadius = 10
        tableViewIngradients.backgroundColor = Color.background
        
        buttonOpenInBrowser.backgroundColor = #colorLiteral(red: 0.9607843161, green: 0.5261413602, blue: 0.200000003, alpha: 1)
        buttonOpenInBrowser.layer.cornerRadius = 10
        buttonOpenInBrowser.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        buttonOpenInBrowser.layer.shadowRadius = 90
        buttonOpenInBrowser.layer.shadowOpacity = 0.4
        buttonOpenInBrowser.layer.shadowOffset = CGSize(width: 3, height: -30)
    }
    
}






