//
//  TypingMessageView.swift
//  crew_chatbot
//
//  Created by Sanju on 04/01/26.
//

import SwiftUI

struct TypingMessageView: View {
    @State private var animating: Bool = true
    
    var body: some View {
        HStack {
            HStack(spacing: 4) {
                ForEach(0..<3) { index in
                    Circle()
                        .fill(Color.gray.opacity(0.6))
                        .frame(width: 6, height: 6)
                        .scaleEffect(animating ? 1.0 : 0.5)
                        .opacity(animating ? 1.0 : 0.3)
                        .animation(
                            Animation.easeInOut(duration: 0.6)
                                .repeatForever(autoreverses: true)
                                .delay(Double(index) * 0.2),
                            value: animating
                        )
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(Color(.systemGray6))
            .cornerRadius(18)
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .onAppear {
            animating = true
        }

    }
}
