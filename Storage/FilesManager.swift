//
//  FilesManager.swift
//  BlockJumble
//
//  Created by Luc-Antoine Dupont on 28/05/2017.
//  Copyright © 2017 Luc-Antoine Dupont. All rights reserved.
//

import Foundation

typealias DataFiles = [String:Any]

enum JSONError: Error {
    case invalid
    case noData
    
    public var errorDescription: String? {
        switch self {
        case .invalid: return "JSON is invalid"
        case .noData: return "no file"
        }
    }
}

enum NameFile: String {
    case artisanList = "artisanList.json"
}

class FilesManager {
    
    func saveFile<T>(nameFile: NameFile, data: T) {
        do {
            try self.writeFile(nameFile: nameFile, content: self.writeJSON(data))
        } catch {
            NSLog(error.localizedDescription)
        }
    }
    
    func readFile<T>(_ JSONData: NameFile) throws -> T {
        guard let file = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { throw JSONError.noData }
        let path = file.appendingPathComponent(JSONData.rawValue)
        let data = try Data(contentsOf: path)
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        guard let object = json as? T else { throw JSONError.invalid }
        return object
    }
    
    func readJSON<T>(_ data: Data) throws -> T {
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        guard let object = json as? T else { throw JSONError.invalid }
        return object
    }
    
    func writeJSON<T, U>(_ jsonObject: U) -> T {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: [])
            let jsonString = String(data: jsonData, encoding: .utf8)!
            return jsonString as! T
        } catch {
            let errorCatched = error.localizedDescription
            NSLog(errorCatched)
            return errorCatched as! T
        }
    }
    
    func writeFile(nameFile: NameFile, content: String) throws {
        guard let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { throw JSONError.noData }
        let path = dir.appendingPathComponent(nameFile.rawValue)
        try content.write(to: path, atomically: false, encoding: String.Encoding.utf8)
    }
    
    func fileModificationDate(_ nameFile: NameFile) throws -> Date? {
        guard let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { throw JSONError.noData }
        let url = dir.appendingPathComponent(nameFile.rawValue)
        do {
            let attr = try FileManager.default.attributesOfItem(atPath: url.path)
            return attr[FileAttributeKey.modificationDate] as? Date
        } catch {
            return nil
        }
    }
    
    func isFileExist(_ nameFile: NameFile) throws -> Bool {
        guard let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { throw JSONError.noData }
        let url = dir.appendingPathComponent(nameFile.rawValue)
        if FileManager.default.fileExists(atPath: url.path) {
            return true
        } else {
            return false
        }
    }
}
