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
    
    var description: String {
        switch self {
            case .nothingFound:
                return "Ooops! \n Nothing found! \n Try to type again and take a look in drop-down list. Also try to  scroll list down."
            case .serverConectionError:
            return "Can't connect to server. Please check your internet connection and try again!"
        }
    }
}
