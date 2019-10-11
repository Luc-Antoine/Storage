//
//  ItemsCell.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 22/06/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
    
    var delegate: ItemCellDelegate?
    var index: Int?
    var favorite: Bool = false
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBAction func favorites() {
        updateFavorite(!favorite)
        delegate?.updateFavorite(index!)
    }
    
    func configureCell(_ item: Item) {
        nameLabel.text = item.name
        updateFavorite(item.favorite)
    }
    
    func updateFavorite(_ favorite: Bool) {
        if favorite {
            favoriteButton.setImage(UIImage(named: "NewStarFavorite"), for: .normal)
            self.favorite = true
        } else {
            favoriteButton.setImage(UIImage(named: "NewStar"), for: .normal)
            self.favorite = false
        }
    }
}
