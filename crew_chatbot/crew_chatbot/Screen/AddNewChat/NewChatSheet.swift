//
//  NewChatSheet.swift
//  crew_chatbot
//
//  Created by Sanju on 04/01/26.
//

import SwiftUI


struct NewChatSheet: View {
    @Environment(\.dismiss) var dismiss
    @State private var title: String = ""
    
    private let crudeHandler: ChatCRUDHandler
    private let onAdd: (Chat) -> Void
    
    init(
        crudeHandler: ChatCRUDHandler,
        onAdd: @escaping (Chat) -> Void
    ) {
        self.crudeHandler = crudeHandler
        self.onAdd = onAdd
    }
    
    var body: some View {
        NavigationView {
            // TODO: Reconsider using of Form
            Form {
                TextField("Chat Title", text: $title)
            }
            .navigationTitle("New Conversation")
            .toolbar {
                Button("Save") {
                    guard let chat = crudeHandler.createChat(title: title) else {
                        return
                    }
                    onAdd(chat)
                    dismiss()
                }
                .disabled(title.isEmpty)
            }
        }
    }
}
