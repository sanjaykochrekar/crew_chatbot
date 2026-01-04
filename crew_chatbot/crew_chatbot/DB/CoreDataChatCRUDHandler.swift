//
//  CoreDataChatCRUDHandler.swift
//  crew_chatbot
//
//  Created by Sanju on 04/01/26.
//

import CoreData


protocol ChatCRUDHandler {
    func delete(chat: Chat) -> Bool
    func createChat(title: String) -> Chat?
}


final class CoreDataChatCRUDHandler: ChatCRUDHandler {
    private let controller: ChatPersistantController = ChatPersistantController.shared

    func delete(chat: Chat) -> Bool {
        return true
    }

    func createChat(title: String) -> Chat? {
        let chat = Chat(context: controller.container.viewContext)
        chat.id = UUID()
        chat.title = title
        chat.lastMessage = "Start of a new conversation"
        chat.lastMessageTimestamp = Date()
        chat.createdAt = Date()
        chat.updatedAt = Date()
        
        guard let _ = try? controller.container.viewContext.save() else {
            return nil
        }
        return chat
    }
    
}
