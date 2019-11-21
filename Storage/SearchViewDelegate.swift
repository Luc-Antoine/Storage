//
//  SearchViewDelegate.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 20/11/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import Foundation

protocol SearchViewDelegate: AnyObject {
    func textFieldDidResearching(_ text: String)
    func newChildSettings()
    func removeSearch()
    func researching(_ text: String?)
}
