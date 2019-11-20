//
//  SortViewController.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 20/11/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class SortViewController: UIViewController {
    var viewModel: SortViewModel?
    
    var data: String = ""
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var sortSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sortSegmentedControl.font()
        sortSegmentedControl.selectedSegmentIndex = viewModel?.sortIndex(data) ?? 0
    }
    
    @IBAction func removeView() {
        remove()
        viewModel?.newChildSettings()
    }
    
    @IBAction func sortChoice() {
        viewModel?.sortIndex(data, sortSegmentedControl.selectedSegmentIndex)
    }
}
