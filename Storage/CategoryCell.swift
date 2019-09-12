//
//  CategoryCell.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 02/06/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {
    
    weak var delegate: CategoryCellDelegate?
    var index: Int?
    var favorite: Bool = false
    
    @IBOutlet weak var nameCategory: UILabel!
    @IBOutlet weak var buttonFavorites: UIButton!
    
    @IBAction func favorites(_ sender: Any) {
        update(!favorite)
        delegate?.updateFavorite(index!)
    }
    
    func configureCell(_ category: Category) {
        nameCategory.text = category.name
        update(category.favorite)
    }
    
    func update(_ favorite: Bool) {
        if favorite {
            buttonFavorites.setImage(UIImage(named: "NewStarFavorite"), for: .normal)
            self.favorite = true
        } else {
            buttonFavorites.setImage(UIImage(named: "NewStar"), for: .normal)
        }
    }
}
