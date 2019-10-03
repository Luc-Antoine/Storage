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
    
    weak var addAnnotationDelegate: AddAnnotationDelegate?
    weak var removeAnnotationDelegate: RemoveAnnotationDelegate?

//    var cells: [AnnotationView] = []
    var annotations: [Annotation] = []
    var annotation: Annotation?
    var lat: Double?
    var lng: Double?
    var index: Int?
    var add: Bool = false
    var fromMap: Bool = false
    
    @IBOutlet weak var mapButton: UIBarButtonItem!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var titleBackView: UIView!
    @IBOutlet weak var subtitleBackView: UIView!
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var subtitleTextField: UITextField!
    
    @IBOutlet weak var commentTextView: UITextView!
    
    private let db = DataBase()
    private let annotationList = AnnotationList()
    private let preferences = Preferences()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        data()
        delegates()
        design()
        prepareTableView()
        tapGestureReconizer()
    }
    
    // MARK: - IBActions
    
    @IBAction func goToMap(_ sender: Any) {
        
    }
    
    @IBAction func confirm() {
        guard titleTextField!.text != "" && subtitleTextField!.text != "" else { return }
        annotationList.update(Annotation(id: 0, title: titleTextField!.text!, subtitle: subtitleTextField!.text!, comment: commentTextView.text ?? "", lat: lat!, lng: lng!, favorite: annotation!.favorite))
        let _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addAnnotation() {
        guard titleTextField!.text != "" && subtitleTextField!.text != "" else {
            if titleTextField!.text == "" {
                titleTextField!.becomeFirstResponder()
            } else {
                subtitleTextField!.becomeFirstResponder()
            }
            return
        }
        annotationList.add(Annotation(id: 0, title: titleTextField!.text!, subtitle: subtitleTextField!.text!, comment: commentTextView.text ?? "", lat: lat!, lng: lng!, favorite: false))
        let _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deleteAnnotation() {
        let redAlert = UIAlertController(title: String(format: NSLocalizedString("Alert", comment: "")), message: String(format: NSLocalizedString("Data lost", comment: "")), preferredStyle: UIAlertController.Style.alert)
        redAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            self.removeAnnotation()
        }))
        redAlert.addAction(UIAlertAction(title: String(format: NSLocalizedString("Cancel", comment: "")), style: .cancel, handler: nil))
        present(redAlert, animated: true, completion: nil)
    }
    
    @IBAction func cancel() {
        titleTextField!.text = ""
        subtitleTextField!.text = ""
        let _ = navigationController?.popViewController(animated: true)
    }
    
    // Table View Data Source
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        switch cells[indexPath.row] {
//        case .buttonAnnotation:
//            return 78
//        case .titleAnnotation:
//            return 84
//        case .subtitleAnnotation:
//            return 84
//        case .commentAnnotation:
//            return 180
//        }
//    }
    
    func prepareTableView() {
        if addAnnotationDelegate != nil {
            add = true
        }
        if fromMap {
            mapButton.isEnabled = false
            mapButton.image = nil
        }
//        cells = [.buttonAnnotation, .titleAnnotation, .subtitleAnnotation, .commentAnnotation]
    }
    
    // MARK: - Private functions
    
    private func removeAnnotation() {
        annotationList.remove([annotation!])
        removeAnnotationDelegate?.removeAnnotation(annotation: annotation!)
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Design
    
    private func data() {
        guard annotation != nil else { return }
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
        
        if fromMap {
            confirmButton.isHidden = true
            deleteButton.isHidden = true
        } else {
            addButton.isHidden = true
            cancelButton.isHidden = true
        }
    }
    
    private func delegates() {
        titleTextField.delegate = self
        subtitleTextField.delegate = self
        commentTextView.delegate = self
        
        confirmButton.borderFocus()
        addButton.borderFocus()
        deleteButton.borderFocus()
        cancelButton.borderFocus()
    }
    
    private func disableMapButton() {
        mapButton.image = nil
        mapButton.isEnabled = false
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
    
    //textViewShouldRetu
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
