//
//  AnnotationDetailsTableViewController.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 30/09/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class AnnotationDetailsTableViewController: UITableViewController {
    
    enum AnnotationAction {
        case add, close, confirm, delete
    }
    
    weak var mapViewControllerDelegate: MapViewControllerDelegate?
    weak var removeAnnotationDelegate: RemoveAnnotationDelegate?

    var annotations: [Annotation] = []
    var annotation: Annotation?
    var distance: String = ""
    var lat: Double?
    var lng: Double?
    var index: Int?
    var fromMap: Bool = false
    
    @IBOutlet weak var buttonsView: UIView!
    @IBOutlet weak var mapButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var titleBackView: UIView!
    @IBOutlet weak var subtitleBackView: UIView!
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var subtitleTextField: UITextField!
    
    @IBOutlet weak var commentTextView: UITextView!
    
    private let db = DataBase()
    private let annotationList = AnnotationList()
    private let location = Location()
    private let preferences = Preferences()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBarDesign()
        navigationBack()
        navigationItem.title = distance
        data()
        delegates()
        design()
        prepareTableView()
        tapGestureReconizer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard annotation != nil else { return }
        mapViewControllerDelegate?.detailsLastAnnotation(annotation!)
    }
    
    // MARK: - IBActions
    
    @IBAction func goToMap() {
        newMapViewController()
    }
    
    @IBAction func save() {
        guard titleTextField!.text != "" && subtitleTextField!.text != "" else {
            if titleTextField!.text == "" {
                titleTextField!.becomeFirstResponder()
            } else {
                subtitleTextField!.becomeFirstResponder()
            }
            return
        }
        let newAnnotation = Annotation(id: annotation?.id ?? 0, title: titleTextField!.text!, subtitle: subtitleTextField!.text!, comment: commentTextView.text ?? "", lat: lat!, lng: lng!, favorite: annotation?.favorite ?? false, categories: [])
        if annotation != nil {
            annotationList.update(newAnnotation)
            mapViewControllerDelegate?.updateAnnotation(newAnnotation)
        } else {
            annotation = newAnnotation
            annotationList.add(newAnnotation)
            mapViewControllerDelegate?.addAnnotation(newAnnotation)
        }
        let _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func goToAnnotationCategories() {
        newAnnotationCategoriesTableViewController()
    }
    
    // MARK: - Navigation
    
    func newMapViewController() {
        let mapViewController: MapViewController = instantiate("MapViewController", storyboard: "Map")
        mapViewController.annotation = annotation
        navigationController?.pushViewController(mapViewController, animated: true)
    }
    
    func newAnnotationCategoriesTableViewController() {
        let annotationCategoriesTableViewController: AnnotationCategoriesTableViewController = instantiate("AnnotationCategoriesTableViewController", storyboard: "AnnotationCategories")
        annotationCategoriesTableViewController.delegate = self
//        annotationCategoriesTableViewController.categoriesSelected = annotation?.categories.compactMap{ $0.wholeNumberValue} ?? []
        annotationCategoriesTableViewController.categoriesSelected = annotation?.categories ?? []
        navigationController?.pushViewController(annotationCategoriesTableViewController, animated: true)
    }
    
    func prepareTableView() {
        if fromMap {
            mapButton.isEnabled = false
            mapButton.image = nil
        } else {
            mapButton.isEnabled = true
            mapButton.image = UIImage(named: "Mappin")
        }
    }
    
    // MARK: - Private functions
    
    private func removeAnnotation() {
        annotationList.remove([annotation!])
        removeAnnotationDelegate?.removeAnnotation(annotation: annotation!)
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Design
    
    private func data() {
        guard annotation != nil else {
            navigationItem.title = NSLocalizedString("New address", comment: "")
            titleTextField.becomeFirstResponder()
            return
        }
        lat = annotation!.lat
        lng = annotation!.lng
        titleTextField.text = annotation!.title
        subtitleTextField.text = annotation!.subtitle
        commentTextView.text = annotation!.comment
        disableMapButton()
    }
    
    private func design() {
        titleBackView.borderActive()
        subtitleBackView.borderActive()
        commentTextView.borderActive()
    }
    
    private func delegates() {
        titleTextField.delegate = self
        subtitleTextField.delegate = self
        commentTextView.delegate = self
        buttonsView.borderFocus()
    }
    
    private func disableMapButton() {
        mapButton.image = nil
        mapButton.isEnabled = false
    }
}

// MARK: - UITextFieldDelegate

protocol AnnotationCategoriesDelegate: AnyObject {
    func update(_ categoriesId: [Int])
}

extension AnnotationDetailsTableViewController: AnnotationCategoriesDelegate {
    func update(_ categoriesId: [Int]) {
        guard annotation != nil else { return }
//        let stringArray: [String] = categoriesId.map{ String($0) }
//        annotation!.categories = stringArray.joined(separator: ",")
        annotation!.categories = categoriesId
        annotationList.update(annotation!)
    }
}

// MARK: - UITextFieldDelegate

extension AnnotationDetailsTableViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 0 {
            titleBackView.borderFocus()
        } else {
            subtitleBackView.borderFocus()
        }
        tableView.scrollToRow(at: IndexPath(row: textField.tag + 1, section: 0), at: .top, animated: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.text = textField.text?.removingEndingSpaces()
        if textField.tag == 0 {
            titleBackView.borderActive()
        } else {
            subtitleBackView.borderActive()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 0:
            subtitleTextField.becomeFirstResponder()
            break
        case 1:
            commentTextView.becomeFirstResponder()
            break
        default:
            break
        }
        return false
    }
}

// MARK: - UITextViewDelegate

extension AnnotationDetailsTableViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.borderFocus()
        tableView.scrollToRow(at: IndexPath(row: 3, section: 0), at: .top, animated: true)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.text = textView.text.removingEndingSpaces()
        textView.borderActive()
    }
}

// MARK: - UIGestureRecognizerDelegate

extension AnnotationDetailsTableViewController: UIGestureRecognizerDelegate {
    
    private func tapGestureReconizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AnnotationDetailsTableViewController.dismissKeyboard(_:)))
        tapGesture.cancelsTouchesInView = true
        tableView.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        titleTextField.resignFirstResponder()
        subtitleTextField.resignFirstResponder()
        commentTextView.resignFirstResponder()
    }
}
