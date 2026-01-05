//
//  FileManager+Util.swift
//  crew_chatbot
//
//  Created by Sanju on 05/01/26.
//

import Foundation


extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
