//
//  ImageSaver.swift
//  crew_chatbot
//
//  Created by Sanju on 05/01/26.
//

import UIKit

class ImageSaver {

    func writeToDisk(image: UIImage, imageName: String) -> String {
        let savePath = FileManager.documentsDirectory.appendingPathComponent("\(imageName).jpg")
        if let jpegData = image.jpegData(compressionQuality: 0.5) {
            try? jpegData.write(to: savePath, options: [.atomic, .completeFileProtection])
        }
        
        return savePath.absoluteString
    }
}
