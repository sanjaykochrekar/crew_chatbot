//
//  Date+Util.swift
//  crew_chatbot
//
//  Created by Sanju on 04/01/26.
//

import Foundation

extension Date {
    func timeAgo() -> String {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self, to: now)
        
        // 1. Just Now (Less than 1 minute)
        if let second = components.second, second < 60, components.minute == 0 {
            return "Just Now"
        }
        
        // 2. Minutes ago (e.g., 2m ago)
        if let minute = components.minute, minute < 60, components.hour == 0 {
            return "\(minute)m ago"
        }
        
        // 3. Today (e.g., 14:20)
        if calendar.isDateInToday(self) {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm" // Or "h:mm a" for AM/PM
            return formatter.string(from: self)
        }
        
        // 4. Yesterday
        if calendar.isDateInYesterday(self) {
            return "Yesterday"
        }
        
        // 5. This Year (e.g., Dec 20)
        if let year = components.year, year == 0 {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d"
            return formatter.string(from: self)
        }
        
        // 6. Older (e.g., 12/20/23)
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yy"
        return formatter.string(from: self)
    }
    
    func toTimeString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        return formatter.string(from: self)
    }
}
