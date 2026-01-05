//
//  ChatDetailViewModel.swift
//  crew_chatbot
//
//  Created by Sanju on 04/01/26.
//

import Combine
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
        messageCrudHandler: MessageCrudHandler,
        bot: Bot
    ) {
        self.chat = chat
        self.bot = bot
        self.messageCrudHandler = messageCrudHandler
        
        messages = messageCrudHandler.getMessages()
        
        messageCrudHandler.onMessagesUpadte = { [weak self] messages in
            guard let self else { return }
            self.messages = messages
        }
    }
    
    func add(_ text: String, image: UIImage? = nil) {
        messageCrudHandler.add(text, type: .user, image: image)
        debouncer.debounce { [weak self] in
            guard let self else { return }
            Task {
                await self.getAnswer()
            }
        }
    }
    
    private func getAnswer() async {
        thinking = true
        
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
            messageCrudHandler.add(text, type: .agent, image: nil)
        }
        
        thinking = false
    }
}
