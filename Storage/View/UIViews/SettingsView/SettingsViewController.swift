//
//  SettingsViewController.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 23/11/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    var viewModel: SettingsViewModel?
    var data: String = ""
    var filterCount: Int = 0
    var searchCount: Int = 0
    
    @IBOutlet weak var buttonsView: UIView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonsView.borderFocus()
        buttonsView.clipsToBounds = true
        titles()
        searchTitle()
        filterTitle()
    }
    
    @IBAction func edit() {
        remove()
        viewModel?.navigationSettings(0)
    }
    
    @IBAction func sort() {
        remove()
        viewModel?.navigationSettings(1)
    }
    
    @IBAction func search() {
        remove()
        viewModel?.navigationSettings(2)
    }
    
    // MARK: - Private Functions
    
    private func titles() {
        switch data {
        case "categories":
            break
        case "items":
            searchButton.setTitle(NSLocalizedString("Filter", comment: ""), for: .normal)
            break
        case "annotations":
            editButton.setTitle(NSLocalizedString("Modify", comment: ""), for: .normal)
            break
        default:
            break
        }
    }
    
    private func filterTitle() {
        guard filterCount > 0 else { return }
        searchButton.backgroundColor = UIColor.mainColor
        searchButton.setTitleColor(UIColor.white, for: .normal)
        if Locale.current.languageCode == "fr" {
            if filterCount > 1 {
                searchButton.setTitle("\(filterCount) Filtres", for: .normal)
            } else {
                searchButton.setTitle("\(filterCount) Filtre", for: .normal)
            }
        } else {
            searchButton.setTitle("\(filterCount) " + NSLocalizedString("Filter", comment: ""), for: .normal)
        }
    }
    
    private func searchTitle() {
        guard searchCount > 0 else { return }
        searchButton.backgroundColor = UIColor.mainColor
        searchButton.setTitleColor(UIColor.white, for: .normal)
    }

}