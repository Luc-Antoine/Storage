//
//  AllFeaturesTableViewController.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 15/08/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class AllFeaturesTableViewController: UITableViewController {
    
    weak var controller: AllFeaturesController?

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - TableView Datasource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return controller!.features.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AllFeaturesTableViewCell.identifier, for: indexPath) as! AllFeaturesTableViewCell
        cell.configureCell(controller!.features[indexPath.row].name + " \(controller!.features[indexPath.row].count)")
        return cell
    }
    
    // MARK: - TableView Delegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        controller!.update(controller!.features[indexPath.row])
        controller!.close()
    }

}
