//
//  Main.swift
//  Recipe Search
//
//  Created by Vasyl Travlinskyy on 09.09.2020.
//  Copyright © 2020 Vasyl Travlinskyy. All rights reserved.
//

import UIKit

class Main: UIViewController {

    @IBOutlet weak var searchBarMockUp: UISearchBar!
    @IBOutlet weak var searchButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBarMockUp.hideBorder()
    }
    

    @IBAction func startSearch(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if #available(iOS 13.0, *) {
            let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
            sceneDelegate?.window?.rootViewController = appDelegate.splitViewController
        } else {
            appDelegate.window?.rootViewController =  appDelegate.splitViewController
        }
    }
    
  

}
