//
//  CategoryViewController.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 01/05/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController {
    
    var controller: CategoryController?
    
    var category: [Category] = []
    
    @IBOutlet weak var tableViewContainer: UIView!
    @IBOutlet weak var settingsContainer: UIView!
    
    //private let controller = CategoryController()
    //private let styleCSS = StyleCSS()

    override func viewDidLoad() {
        super.viewDidLoad()

        controller!.instantiateCategorySettings()
        controller!.instantiateCategoryTableViewController(categoryViewController: self, container: tableViewContainer)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Open Functions
    
    private func design() {
//        containerView.isHidden = true
//        editView.isHidden = true
//        searchView.isHidden = true
//        sortView.isHidden = true
//        addView.isHidden = true
//        styleCSS.borderTextField(textFields: [searchBar, addBar, editBar])
    }
    
    private func firstTime() {
        controller!.firstTime()
    }

}
