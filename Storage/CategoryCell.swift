//
//  CategoryCell.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 02/06/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {
    
    var thisCategory: Category?
    var favorites: Bool = false
    
    @IBOutlet weak var nameCategory: UILabel!
    @IBOutlet weak var buttonFavorites: UIButton!
    
    private let db = DataBase()
    
    @IBAction func favorites(_ sender: Any) {
        db.setFavorites(category: thisCategory!, favorites: favorites)
        NotificationCenter.default.post(name: .reload, object: nil)
    }
    
    func configureCell(with cell: Category, index: Int) {
        nameCategory.text = cell.name!
        favorites = cell.favorites
    }
    
    func colorCell() {
        buttonFavorites.setImage(#imageLiteral(resourceName: "NewStar"), for: .normal)
    }
    
    func colorFavorites() {
        buttonFavorites.setImage(#imageLiteral(resourceName: "NewStarFavorite"), for: .normal)
    }
}
