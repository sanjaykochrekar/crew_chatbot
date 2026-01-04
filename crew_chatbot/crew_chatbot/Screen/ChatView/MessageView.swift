//
//  MessageView.swift
//  crew_chatbot
//
//  Created by Sanju on 04/01/26.
//

import SwiftUI
import Kingfisher

struct MessageView: View {
    let message: Message
    
    @State private var isShowingFullScreen = false
    
    var body: some View {
        HStack {
            if message.senderType == .user {
                Spacer()
            }
            
            VStack(alignment: .leading) {
                if message.type == .file, let url = URL(
                    string: message.file?.path ?? "https://picsum.photos/id/237/600/1200"
                ) {
                    KFImage(url)
                        .resizable()
                        .aspectRatio(1.0, contentMode: .fit)
                        .onTapGesture {
                            isShowingFullScreen.toggle()
                        }
                        .fullScreenCover(isPresented: $isShowingFullScreen) {
                            ZoomableImageView(url: url)
                        }
                    Text("\(getReadableFileSize(message.file?.fileSize ?? 0))")
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
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
            .padding(message.senderType == .user ? .leading : .trailing, 24)
            
            if !(message.senderType == .user) {
                Spacer()
            }
        }
        .padding(.horizontal)
       
    }
    
    func getReadableFileSize(_ size: Int64) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useAll]
        formatter.countStyle = .file
        formatter.isAdaptive = true
        
        return formatter.string(fromByteCount: size)
    }
}
