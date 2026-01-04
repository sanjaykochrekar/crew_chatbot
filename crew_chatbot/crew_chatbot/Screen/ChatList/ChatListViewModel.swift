//
//  ChatListViewModel.swift
//  crew_chatbot
//
//  Created by Sanju on 04/01/26.
//

import CoreData
import Combine

final class ChatListViewModel: ObservableObject {
    private let charCurdHandler: ChatCRUDHandler

    @Published var chats: [Chat] = []
    
    init(charCurdHandler: ChatCRUDHandler = CoreDataChatCRUDHandler()) {
        self.charCurdHandler = charCurdHandler
        self.chats = charCurdHandler.getChats()
        
        charCurdHandler.onUpdateChat = { [weak self] list in
            guard let self else { return }
            chats = list
        }
    }
    
    func refreshChats() {
        self.chats = charCurdHandler.getChats()
    }
    
    func getChatHandler() -> ChatCRUDHandler {
        self.charCurdHandler
    }
    
    func delete(chat: Chat) {
        charCurdHandler.delete(chat: chat)
    }
}
