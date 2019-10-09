//
//  AnnotationModaleWindowViewController.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 09/10/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class AnnotationModaleWindowViewController: UIViewController {
    
    weak var delegate: AnnotationModaleWindowDelegate?
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    // MARK: - IBActions
    
    @IBAction func removeView() {
        delegate?.removeView()
    }
    
    @IBAction func showAnnotation() {
        delegate?.showAnnotation()
    }
    
    // MARK: - Function
    
    func configureView(distance: String, title: String, subtitle: String) {
        distanceLabel.text = distance
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }
}
