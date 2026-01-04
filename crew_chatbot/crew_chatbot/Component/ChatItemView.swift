//
//  ChatItemView.swift
//  crew_chatbot
//
//  Created by Sanju on 04/01/26.
//

import SwiftUI

struct ChatItemView: View {
    @ObservedObject private var chat: Chat
    
    init(chat: Chat) {
        self.chat = chat
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(chat.title ?? "")
                Spacer()
                Text(chat.lastMessageTimestamp?.timeAgo() ?? "")
                    .font(.caption)
            }
            Text(chat.lastMessage ?? "")
                .lineLimit(2)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}
