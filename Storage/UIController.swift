//
//  UIController.swift
//  GoodFood
//
//  Created by Luc-Antoine Dupont on 25/07/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class UIController {
    
    // [LAD] Voici l'enum qui gère les erreurs, par exemple lorsque le type n'est pas bon...
    enum ControllerError: LocalizedError {
        case badType(view: String, type: String)
        case fileNotFound(file: String)
        
        public var errorDescription: String? {
            switch self {
            case .badType(let view, let type):
                return NSLocalizedString(view + " not cast to type : " + type, comment: "Bad Type")
                
            case .fileNotFound(let file):
                return NSLocalizedString(file + " not found", comment: "File not found")
            }
        }
    }
    
    // [LAD] La fonction qui me permet d'instancier les storyboard, comme prepareForSegue
    func instantiate<T>(_ identifier: String, storyboard name: String, bundle: Bundle?) -> T {
        let storyboard = UIStoryboard(name: name, bundle: bundle)
        let viewController = storyboard.instantiateViewController(withIdentifier: identifier) as! T
        return viewController
    }
    
    // [LAD] La fonction qui instancie les views childs
    func instantiate<T>(_ nibname: String, owner: Any?, options: [UINib.OptionsKey : Any]?) -> T {
        let views = Bundle.main.loadNibNamed(nibname, owner: nil, options: nil)
        return views?.first as! T
    }
    
    // [LAD] La fonction qui affiche les UIViewController
    func child(_ parent: UIViewController, child: UIViewController, container: UIView) {
        parent.addChild(child)
        child.view.frame.size = container.frame.size
        container.addSubview(child.view)
    }
    
    // [LAD] La fonction qui affiche les childs View
    func child(_ child: UIView, container: UIView) {
        child.frame.size = container.frame.size
        container.addSubview(child)
    }
    
    // [LAD] La nouvelle fonction avec gestion d'erreur, mais elle n'est pas finie...
    func child<T>(_ nibname: String, container: UIView, owner: Any? = nil, options: [UINib.OptionsKey : Any]? = nil) -> T {
        var view: T?
        let views = Bundle.main.loadNibNamed(nibname, owner: nil, options: nil)
        let child = views?.first as! UIView
        child.frame.size = container.frame.size
        container.addSubview(child)
        do {
            view = try instantiate(child)
        } catch {
            NSLog(error.localizedDescription)
        }
        return view!
    }
    
    // [LAD] La fonction qui affiche les UIViewControllers dans un UINavigaationController
    func push(_ navigationController: UINavigationController, viewController: UIViewController) {
        navigationController.pushViewController(viewController, animated: true)
    }
    
    // MARK: - Error Functions
    
    // [LAD] La fonction pour gérer les erreurs de type qui ne fonctionne pas...
    private func instantiate<T>(_ view: UIView) throws -> T? {
        guard let result = view as? T else {
            throw ControllerError.badType(view: String(describing: view.self), type: String(describing: T.self))
        }
        return result
    }
}
