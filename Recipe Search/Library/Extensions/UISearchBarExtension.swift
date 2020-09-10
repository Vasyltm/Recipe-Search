//
//  File.swift
//  Recipe Search
//
//  Created by Vasyl Travlinskyy on 08.09.2020.
//  Copyright © 2020 Vasyl Travlinskyy. All rights reserved.
//

import UIKit
import Foundation


extension UISearchBar {
    
    
    func hideBorder() {
        backgroundImage = UIImage()
        if #available(iOS 13.0, *) {
        } else {
            layer.borderColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)// Color.backgroundCG
            layer.cornerRadius = 20
            layer.borderWidth = 1
        }
    }
    
}
