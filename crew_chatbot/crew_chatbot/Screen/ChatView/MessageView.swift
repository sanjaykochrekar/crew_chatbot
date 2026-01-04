//
//  MessageView.swift
//  crew_chatbot
//
//  Created by Sanju on 04/01/26.
//

import SwiftUI

struct MessageView: View {
    let message: Message
    
    var body: some View {
        HStack {
            if message.senderType == .user {
                Spacer()
            }
            
            VStack(alignment: .leading) {
                
                Text(message.text ?? "")
                    .font(.body)
                Text(message.timestamp?.toTimeString() ?? "")
                    .font(.caption)
                    .frame(alignment: .trailing)
            }
            .padding(10)
            .foregroundColor(message.senderType == .user ? Color.white : Color.black)
            .background(message.senderType == .user ? Color.blue : Color.gray)
            .cornerRadius(10)
            
            if !(message.senderType == .user) {
                Spacer()
            }
        }
        .padding(.horizontal)
    }
}
