//
//  InitialDBDataSetupHandler.swift
//  crew_chatbot
//
//  Created by Sanju on 05/01/26.
//

import Foundation
import CoreData

final class InitialDBDataSetupHandler {
    
    func addData() {
        let context = ChatPersistantController.shared.container.viewContext
            //        ChatPersistantController.shared.container.performBackgroundTask { [weak self] context in
            //            guard let self else { return }
        let titles = ["Hotel Reservation Help",  "Restaurant Recommendations", "Mumbai Flight Booking"]
        var chatItem: Chat?
        for title in titles {
            let chat = Chat(context: context)
            chat.id = UUID()
            chat.title = title
            chat.createdAt = Date()
            chat.updatedAt = Date()
            chatItem = chat
        }
        
        if let chatItem {
            let messages = self.loadChatData(fileName: "messages")
            for message in messages {
                let newMessage = Message(context: context)
                newMessage.id = UUID()
                newMessage.text = message.message
                newMessage.timestamp = Date()
                newMessage.senderValue = message.sender
                newMessage.chat = chatItem
                
                if let image = message.file?.path {
                    let fileMeta = FileAttachment(context: context)
                    fileMeta.path = image
                    
                        //TODO: Size uidate size
                    fileMeta.fileSize = 2413
                    fileMeta.thumbnailPath = "thumbPath"
                    newMessage.file = fileMeta
                    newMessage.typeValue = "file"
                } else {
                    newMessage.typeValue = "text"
                }
                
                if messages.last?.id == message.id {
                    chatItem.lastMessage = message.message
                    chatItem.lastMessageTimestamp = Date()
                    chatItem.updatedAt = Date()
                }
            }
            
        }
        try? context.save()
        
    }
    
    func loadChatData(fileName: String) -> [ChatMessage] {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            print("File not found: \(fileName).json")
            return []
        }
        
        do {
            let data = try Data(contentsOf: url)
            
            let decoder = JSONDecoder()
            let messages = try decoder.decode([ChatMessage].self, from: data)
            
            return messages
        } catch {
            print("Error decoding JSON: \(error)")
            return []
        }
    }
}

struct ChatMessage: Codable, Identifiable {
    let id: String
    let message: String
    let type: String
    let sender: String
    let timestamp: Int64
    let file: FileData?
}

struct FileData: Codable {
    let path: String
    let fileSize: Int64
    let thumbnail: ThumbnailData?
}

struct ThumbnailData: Codable {
    let path: String
}
