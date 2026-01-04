//
//  ChatDetailViewModel.swift
//  crew_chatbot
//
//  Created by Sanju on 04/01/26.
//

import Combine
import CoreData
import SwiftUI

final class ChatDetailViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var thinking: Bool = false
    
    private let chat: Chat
    private let bot: Bot
    private let messageCrudHandler: MessageCrudHandler
    private let debouncer = Debouncer(delay: 1.0)
    
    init(
        chat: Chat,
        bot: Bot = MessageBot(),
        context: NSManagedObjectContext = ChatPersistantController.shared.container.viewContext
    ) {
        self.chat = chat
        self.bot = bot
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
            Task {
                await self.getAnswer()
            }
        }
    }
    
    private func getAnswer() async {
//        withAnimation {
            thinking = true
//        }
        
        let response = await bot.onResponseRecieved()
        
        if case .file(let path) = response {
            messageCrudHandler
                .sendFileMessage(
                    path: path,
                    size: 12898,
                    thumbPath: "",
                    type: .agent
                )
        } else if case .text(let text) = response {
            messageCrudHandler.add(text, type: .agent)
        }
        
//        withAnimation {
            thinking = false
//        }
    }
}
