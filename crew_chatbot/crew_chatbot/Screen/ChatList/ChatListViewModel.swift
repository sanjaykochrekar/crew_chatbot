//
//  ChatListViewModel.swift
//  crew_chatbot
//
//  Created by Sanju on 04/01/26.
//

import CoreData
import Combine

final class ChatListViewModel: ObservableObject {
    private let chatCurdHandler: ChatCRUDHandler

    @Published var chats: [Chat] = []
    
    init(chatCurdHandler: ChatCRUDHandler) {
        self.chatCurdHandler = chatCurdHandler
        self.chats = chatCurdHandler.getChats()
        
        chatCurdHandler.onUpdateChat = { [weak self] list in
            guard let self else { return }
            chats = list
        }
    }
    
    func getChatHandler() -> ChatCRUDHandler {
        self.chatCurdHandler
    }
    
    func delete(chat: Chat) {
        chatCurdHandler.delete(chat: chat)
    }
}
