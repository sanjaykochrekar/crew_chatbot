//
//  Message+CoreDataUtil.swift
//  crew_chatbot
//
//  Created by Sanju on 04/01/26.
//

import CoreData

extension Message {
    enum MessageType: String {
        case text, file
    }
    
    enum SenderType: String {
        case user
        case agent
    }
    
    var type: MessageType {
        get { MessageType(rawValue: typeValue ?? "text") ?? .text }
        set { typeValue = newValue.rawValue }
    }
    
    var senderType: SenderType {
        get { SenderType(rawValue: senderValue ?? "user") ?? .user}
    }
}
