//
//  ServerHandler.swift
//  Recipe Search
//
//  Created by Vasyl Travlinskyy on 08.09.2020.
//  Copyright © 2020 Vasyl Travlinskyy. All rights reserved.
//


import Foundation



public enum ChooseAction {
    case getRecipeOnSearchButton
    case loadMoreRecipes
    case getIngradients
}


struct ServerHandler {
    
    
    let config: URLSessionConfiguration = {
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        config.timeoutIntervalForResource = 200
        return config
    }()
    var task: URLSessionDataTask?
    
    lazy var session = URLSession(configuration: config)
    
    mutating func request (_ action: ChooseAction = .getRecipeOnSearchButton, searchFor: String = "", onPage: String = "1", completion: @escaping (Result<[String: Any], Error>) -> Void) {
        
        var api = "https://recipesapi.herokuapp.com/api/"
        
        
        
        switch action {
            case .loadMoreRecipes, .getRecipeOnSearchButton:
                api = api + "search?q=" + String(searchFor.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") + "&page=" + onPage
            case .getIngradients:
                api = api + "get?rId=" + searchFor
        }
         
        let urlOptional = URL(string: api)
        
        guard let url = urlOptional else {
            print("wrong url in serverHandler")
            return
        }
        
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        
        
         task = session.dataTask(with: request) { data, response, error in
            
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            
//            if let response = response  {
//                print(response)
//            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String: Any] {
                    completion(.success(json))
                }
            } catch let error {
                completion(.failure(error))
            }
            
        }
        task?.resume()
        
    }
    
    

    
    
    
}

