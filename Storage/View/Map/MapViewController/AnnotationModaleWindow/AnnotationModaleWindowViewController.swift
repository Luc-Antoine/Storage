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
    
    var distanceText: String = ""
    var titleText: String = ""
    var subtitleText: String = ""
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        distanceLabel.text = distanceText
        titleLabel.text = titleText
        subtitleLabel.text = subtitleText
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        remove()
    }
    
    // MARK: - IBActions
    
    @IBAction func showAnnotation() {
        delegate?.showAnnotation()
    }
}

protocol ModaleWindowDelegate: AnyObject {
    func removeView()
}

extension AnnotationModaleWindowViewController: ModaleWindowDelegate {
    func removeView() {
        remove()
    }
}
