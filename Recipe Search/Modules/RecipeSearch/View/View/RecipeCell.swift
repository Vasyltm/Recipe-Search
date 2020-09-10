//
//  RecipeCell.swift
//  Recipe Search
//
//  Created by Vasyl Travlinskyy on 08.09.2020.
//  Copyright © 2020 Vasyl Travlinskyy. All rights reserved.
//

import UIKit

class RecipeCell: UITableViewCell {

    private let recipeImageWidth: CGFloat = 50.0
    
    lazy var recipeImage: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius =  recipeImageWidth / 2
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var recipeTitle: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = .max
        return label
    }()
    
   
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
            contentView.addSubview(recipeImage)
        contentView.addSubview(recipeTitle)
        
        recipeImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 15).isActive = true
        recipeImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        recipeImage.widthAnchor.constraint(equalToConstant: recipeImageWidth).isActive = true
        recipeImage.heightAnchor.constraint(equalToConstant: recipeImageWidth).isActive = true
        
        recipeTitle.layer.cornerRadius = 10
        recipeTitle.leftAnchor.constraint(equalTo: recipeImage.rightAnchor, constant: 10).isActive = true
        recipeTitle.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        recipeTitle.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true
        recipeTitle.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
