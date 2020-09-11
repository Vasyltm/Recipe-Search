//
//  File.swift
//  Recipe Search
//
//  Created by Vasyl Travlinskyy on 10.09.2020.
//  Copyright © 2020 Vasyl Travlinskyy. All rights reserved.
//

import UIKit


extension UIView {
    
 
    func fadeIn(_ duration: TimeInterval? = 0.5, onCompletion: (() -> Void)? = nil) {
        self.alpha = 0
        self.isHidden = false
        UIView.animate(withDuration: duration!, animations: { self.alpha = 1 }) { (value: Bool) in
             if let complete = onCompletion { complete() }
        }
    }
    
    func fadeOut(_ duration: TimeInterval? = 0.5, onCompletion: (() -> Void)? = nil) {
        UIView.animate(withDuration: duration!, animations: { self.alpha = 0 }) { (value: Bool) in
            self.isHidden = true
            self.layer.opacity = 0
            if let complete = onCompletion { complete() }
        }
    }
    
}
