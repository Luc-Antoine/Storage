//
//  String.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 14/08/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import Foundation

extension String {
    func removingEndingSpaces() -> String {
        if self != "" {
            let index = self.index(self.startIndex, offsetBy: self.count-1)
            if self[index...] == " " {
                let index = self.index(self.endIndex, offsetBy: -1)
                return String(self[..<index])
            }
        }
        return self
    }
}
