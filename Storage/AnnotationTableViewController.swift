//
//  AnnotationTableViewController.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 04/08/2018.
//  Copyright © 2018 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

enum AnnotationView {
    case buttonAnnotation, titleAnnotation, subtitleAnnotation, commentAnnotation
}

class AnnotationTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ButtonAnnotationDelegate, TitleAnnotationDelegate, SubtitleAnnotationDelegate, CommentAnnotationDelegate, ScrollToElementEditing {
    
    var cells: [AnnotationView] = []
    
    var lat: Double?
    var lng: Double?
    var scrollViewHeight: CGFloat = 0.0
    var activeField: UITextField?
    var activeTextView: UITextView?
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var annotation: [Annotation]?
    var thisAnnotation: Annotation?
    var index: Int?
    
    var addAnnotationDelegate: AddAnnotationDelegate?
    var removeAnnotationDelegate: RemoveAnnotationDelegate?
    var add: Bool = false
    var fromMap: Bool = false
    
    var annotationTitle: UITextField?
    var annotationSubtitle: UITextField?
    var annotationComment: UITextView?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapButton: UIBarButtonItem!
    
    private let db = DataBase()
    private let preferences = Preferences()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        prepareTableView()
        tapGestureReconizer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        registerForKeyboardNotifications()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MapAnnotation" {
            let destination = segue.destination as! MapViewController
            destination.annotation = annotation!
            destination.thisAnnotation = thisAnnotation!
            destination.lat = thisAnnotation!.lat
            destination.lng = thisAnnotation!.lng
        }
    }
    
    // IBActions
    
    @IBAction func goToMap(_ sender: Any) {
        performSegue(withIdentifier: "MapAnnotation", sender: nil)
    }
    
    // Table View Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch cells[indexPath.row] {
        case .buttonAnnotation:
            let cell = tableView.dequeueReusableCell(withIdentifier: ButtonAnnotationCell.identifier, for: indexPath) as! ButtonAnnotationCell
            cell.buttonAnnotationDelegate = self
            cell.configureCell(add: add)
            return cell
        case .titleAnnotation:
            let cell = tableView.dequeueReusableCell(withIdentifier: TitleAnnotationCell.identifier, for: indexPath) as! TitleAnnotationCell
            cell.titleAnnotationDelegate = self
            cell.scrollToElementEditingDelegate = self
            if add {
                cell.configureCell(title: annotationTitle?.text)
            } else {
                cell.configureCell(title: thisAnnotation?.title)
            }
            return cell
        case .subtitleAnnotation:
            let cell = tableView.dequeueReusableCell(withIdentifier: SubtitleAnnotationCell.identifier, for: indexPath) as! SubtitleAnnotationCell
            cell.subtitleAnnotationDelegate = self
            cell.scrollToElementEditingDelegate = self
            if add {
                cell.configureCell(subtitle: annotationSubtitle?.text)
            } else {
                cell.configureCell(subtitle: thisAnnotation?.subtitle)
            }
            
            return cell
        case .commentAnnotation:
            let cell = tableView.dequeueReusableCell(withIdentifier: CommentAnnotationCell.identifier, for: indexPath) as! CommentAnnotationCell
            cell.commentAnnotationDelegate = self
            cell.scrollToElementEditingDelegate = self
            if add {
                cell.configureCell(comment: annotationComment?.text)
            } else {
                cell.configureCell(comment: thisAnnotation?.comment)
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch cells[indexPath.row] {
        case .buttonAnnotation:
            return 78
        case .titleAnnotation:
            return 84
        case .subtitleAnnotation:
            return 84
        case .commentAnnotation:
            return 180
        }
    }
    
    func prepareTableView() {
        if addAnnotationDelegate != nil {
            add = true
        }
        if fromMap {
            mapButton.isEnabled = false
            mapButton.image = nil
        }
        cells = [.buttonAnnotation, .titleAnnotation, .subtitleAnnotation, .commentAnnotation]
    }
    
    // MARK: - Delegate Functions
    
    func scrollToElementEditing(indexPath: IndexPath) {
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    func actionButtonAnnotation(action: AnnotationAction) {
        switch action {
        case .add:
            addAnnotation()
            break
        case .close:
            close()
            break
        case .confirm:
            updateAnnotation()
            close()
            break
        case .delete:
            deleteAnnotation()
            close()
            break
        }
    }
    
    func setTitleAnnotation(textField: UITextField) {
        annotationTitle = textField
    }
    
    func setSubtitleAnnotation(textField: UITextField) {
        annotationSubtitle = textField
    }
    
    func setCommentAnnotation(textView: UITextView) {
        annotationComment = textView
    }
    
    func getTitle(title: String) {
        annotationTitle?.text = title
        thisAnnotation?.title = title
    }
    
    func getSubtitle(subtitle: String) {
        annotationSubtitle?.text = subtitle
    }
    
    func getComment(comment: String) {
        annotationComment?.text = comment
    }
    
    // MARK: - Annotations Functions
    
    private func addAnnotation() {
        guard annotationTitle?.text != "" && annotationSubtitle?.text != "" else {
            if annotationTitle!.text == "" {
                annotationTitle!.becomeFirstResponder()
            } else {
                annotationSubtitle!.becomeFirstResponder()
            }
            return
        }
//        let thisAnnotation: Annotation = db.addAnnotation(lat: lat!, lng: lng!, title: annotationTitle!.text!, subtitle: annotationSubtitle!.text!, comment: annotationComment!.text!)
//        addAnnotationDelegate?.addAnnotation(annotation: thisAnnotation)
//        let _ = navigationController?.popViewController(animated: true)
    }
    
    private func close() {
        annotationTitle?.text = ""
        annotationSubtitle?.text = ""
        let _ = navigationController?.popViewController(animated: true)
    }
    
    private func deleteAnnotation() {
        let redAlert = UIAlertController(title: String(format: NSLocalizedString("Alert", comment: "")), message: String(format: NSLocalizedString("Data lost", comment: "")), preferredStyle: UIAlertController.Style.alert)
        redAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            self.removeAnnotation()
        }))
        redAlert.addAction(UIAlertAction(title: String(format: NSLocalizedString("Cancel", comment: "")), style: .cancel, handler: nil))
        present(redAlert, animated: true, completion: nil)
    }
    
    private func removeAnnotation() {
        db.deleteAnnotation(annotations: [thisAnnotation!], completion: { success in
            if success {
                DispatchQueue.main.async {
                    self.removeAnnotationDelegate?.removeAnnotation(annotation: self.thisAnnotation!)
                    let _ = self.navigationController?.popViewController(animated: true)
                }
            }
        })
    }
    
    func updateAnnotation() {
        guard annotationTitle?.text != "" && annotationSubtitle?.text != "" else { return }
        db.setAnnotation(annotation: thisAnnotation!, title: annotationTitle!.text!, subtitle: annotationSubtitle!.text!, comment: annotationComment!.text!)
        let _ = navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Keyboard
    
    private func tapGestureReconizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AnnotationTableViewController.hideKeyboard))
        tapGesture.cancelsTouchesInView = true
        tableView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func hideKeyboard() {
        tableView.endEditing(true)
    }
    
    func registerForKeyboardNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    func deregisterFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        let userInfo = notification.userInfo!
        
        let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            tableView.contentInset = UIEdgeInsets.zero
        } else {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - 49, right: 0)
        }
        
        tableView.scrollIndicatorInsets = tableView.contentInset
    }
}

class ButtonAnnotationCell: UITableViewCell {
    
    var buttonAnnotationDelegate: ButtonAnnotationDelegate?
    
    @IBOutlet weak var validButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    private let db = DataBase()
    private let styleCSS = StyleCSS()
    
    @IBAction func add() {
        buttonAnnotationDelegate?.actionButtonAnnotation(action: .add)
    }
    
    @IBAction func cancel() {
        buttonAnnotationDelegate?.actionButtonAnnotation(action: .close)
    }
    
    @IBAction func confirm() {
        buttonAnnotationDelegate?.actionButtonAnnotation(action: .confirm)
    }
    
    @IBAction func delete() {
        buttonAnnotationDelegate?.actionButtonAnnotation(action: .delete)
    }
    
    func configureCell(add: Bool) {
        styleCSS.radiusUIButton(buttons: [validButton, deleteButton, addButton, cancelButton])
        if add {
            validButton.isHidden = true
            deleteButton.isHidden = true
        } else {
            addButton.isHidden = true
            cancelButton.isHidden = true
        }
    }
}

class TitleAnnotationCell: UITableViewCell, UITextFieldDelegate {
    
    var titleAnnotationDelegate: TitleAnnotationDelegate?
    var scrollToElementEditingDelegate: ScrollToElementEditing?
    
    @IBOutlet weak var annotationTitle: UITextField!
    
    private let styleCSS = StyleCSS()
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollToElementEditingDelegate?.scrollToElementEditing(indexPath: IndexPath(row: 1, section: 0))
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        titleAnnotationDelegate?.getTitle(title: annotationTitle.text ?? "")
    }
    
    func configureCell(title: String?) {
        annotationTitle.delegate = self
        annotationTitle.text = title
        titleAnnotationDelegate?.setTitleAnnotation(textField: annotationTitle)
        styleCSS.borderTextField(textFields: [annotationTitle])
    }
}

class SubtitleAnnotationCell: UITableViewCell, UITextFieldDelegate {
    
    var subtitleAnnotationDelegate: SubtitleAnnotationDelegate?
    var scrollToElementEditingDelegate: ScrollToElementEditing?
    
    @IBOutlet weak var annotationSubtitle: UITextField!
    
    private let styleCSS = StyleCSS()
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollToElementEditingDelegate?.scrollToElementEditing(indexPath: IndexPath(row: 2, section: 0))
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        subtitleAnnotationDelegate?.getSubtitle(subtitle: annotationSubtitle.text ?? "")
    }
    
    func configureCell(subtitle: String?) {
        annotationSubtitle.delegate = self
        annotationSubtitle.text = subtitle
        subtitleAnnotationDelegate?.setSubtitleAnnotation(textField: annotationSubtitle)
        styleCSS.borderTextField(textFields: [annotationSubtitle])
    }
}

class CommentAnnotationCell: UITableViewCell, UITextViewDelegate {
    
    var commentAnnotationDelegate: CommentAnnotationDelegate?
    var scrollToElementEditingDelegate: ScrollToElementEditing?
    
    @IBOutlet weak var annotationComment: UITextView!
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        scrollToElementEditingDelegate?.scrollToElementEditing(indexPath: IndexPath(row: 3, section: 0))
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        commentAnnotationDelegate?.getComment(comment: annotationComment.text)
    }
    
    func configureCell(comment: String?) {
        annotationComment.delegate = self
        annotationComment.text = comment
        commentAnnotationDelegate?.setCommentAnnotation(textView: annotationComment)
        borderUITextView(textView: annotationComment)
        annotationComment.border()
    }
    
    func borderUITextView(textView: UITextView) {
        textView.layer.borderColor = UIColor(red: CGFloat(104/255), green: CGFloat(104/255), blue: CGFloat(104/255), alpha: 0.3).cgColor
        textView.layer.borderWidth = 0.5
        textView.layer.cornerRadius = 5.0
    }
}
