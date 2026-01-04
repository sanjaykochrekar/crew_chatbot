//
//  ChatDetailViewModel.swift
//  crew_chatbot
//
//  Created by Sanju on 04/01/26.
//

import Combine
import CoreData

final class ChatDetailViewModel: ObservableObject {
    @Published var messages: [Message] = []
    private let chat: Chat
    private let messageCrudHandler: MessageCrudHandler
    private let debouncer = Debouncer(delay: 1.0)
    
    init(
        chat: Chat,
        context: NSManagedObjectContext = ChatPersistantController.shared.container.viewContext
    ) {
        self.chat = chat
        messageCrudHandler = CoreDataMessageCrudHandler(chat: chat)
        
        messages = messageCrudHandler.getMessages()
        
        messageCrudHandler.onMessagesUpadte = { [weak self] messages in
            guard let self else { return }
            self.messages = messages
        }
    }
    
    func add(_ text: String) {
        messageCrudHandler.add(text, type: .user)
        debouncer.debounce { [weak self] in
            guard let self else { return }
            getAnswer()
        }
    }
    
    private func getAnswer() {
        
    }
}


