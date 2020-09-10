//
//  Recipe.swift
//  Recipe Search
//
//  Created by Vasyl Travlinskyy on 08.09.2020.
//  Copyright © 2020 Vasyl Travlinskyy. All rights reserved.
//

import Foundation


struct Recipe  {
    let id: String
    var image: Data? = nil
    let image_url: String
    let source_url: String
    let title: String
    var ingredients: [String]? 
}

