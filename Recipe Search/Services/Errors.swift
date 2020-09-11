//
//  Errors.swift
//  Recipe Search
//
//  Created by Vasyl Travlinskyy on 10.09.2020.
//  Copyright © 2020 Vasyl Travlinskyy. All rights reserved.
//

import Foundation


enum Errors {
    case nothingFound
    case serverConectionError
    case searchInputTooShort
    
    var description: String {
        switch self {
            case .nothingFound:
                return "Ooops!  \n Nothing found! \n Just make a few steps to find your recipe: \n1. Check your input for mistakes. \n2. Try to type  simle words \n like \"bread\", \"soup\", \"milk\" etc. "
            case .serverConectionError:
                return "Can't connect to server. Please check your internet connection and try again!"
            case .searchInputTooShort:
                return "Can't find recipes! \n Please enter more letters!"
        }
    }
}
