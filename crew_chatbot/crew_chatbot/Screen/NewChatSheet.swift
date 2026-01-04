//
//  NewChatSheet.swift
//  crew_chatbot
//
//  Created by Sanju on 04/01/26.
//

import SwiftUI
import CoreData


struct NewChatSheet: View {
    @Environment(\.dismiss) var dismiss
    @State private var title: String = ""
    
    
    // TODO: Inject this as dependency
    private let crudeHandle: ChatCRUDHandler = CoreDataChatCRUDHandler()
    
    private let onAdd: (Chat) -> Void
    
    init(
        onAdd: @escaping (Chat) -> Void
    ) {
        self.onAdd = onAdd
    }
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Chat Title", text: $title)
            }
            .navigationTitle("New Conversation")
            .toolbar {
                Button("Save") {
                    guard let chat = crudeHandle.createChat(title: title) else {
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
