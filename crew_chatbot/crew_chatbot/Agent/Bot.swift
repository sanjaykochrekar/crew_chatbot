//
//  Bot.swift
//  crew_chatbot
//
//  Created by Sanju on 04/01/26.
//

enum BotResponse {
    case file(String)
    case text(String)
    case none
}

protocol Bot {
    func onResponseRecieved() async -> BotResponse
}


final class MessageBot: Bot {
    
    func onResponseRecieved() async -> BotResponse {
        let shouldReply = Int.random(in: 0...6) > 2
        
        if shouldReply {
            
            let delayTime = UInt64.random(in: 1...2) * 1_000_000_000
            try? await Task.sleep(nanoseconds: delayTime)
            
            let replyType = Double.random(in: 0...1) < 0.7 ? "text" : "file"
            
            switch replyType {
                case "text":
                    let responses = [
                        "I'm looking into that for you.",
                        "Let me check the details.",
                        "Got it! I'll help you with that.",
                        "That's a great question. Here's what I found...",
                        "I've processed your request."
                    ]
                    return .text(responses.randomElement() ?? "")
                case "file":
                    let placeholderImage = "https://picsum.photos/400/300"
                    return .file(placeholderImage)
                default:
                    break
            }
        }
        return .none
    }
    
}
