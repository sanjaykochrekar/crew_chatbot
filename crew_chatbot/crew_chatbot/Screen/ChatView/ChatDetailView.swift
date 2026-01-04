//
//  ChatDetailView.swift
//  crew_chatbot
//
//  Created by Sanju on 04/01/26.
//


import SwiftUI


struct ChatDetailView: View {
    private let chat: Chat
    @State private var loadingAnswer: Bool = false
    @State private var text: String = ""
    @StateObject private var viewModel: ChatDetailViewModel
    
    init(chat: Chat) {
        self.chat = chat
        let vm = ChatDetailViewModel(chat: chat)
        self._viewModel = StateObject(wrappedValue: vm)
    }
    
    var body: some View {
        GeometryReader { geo in
            ScrollViewReader { proxy in
                ZStack(alignment: .bottom) {
                    ScrollView {
                        LazyVStack {
                            ForEach(viewModel.messages) { message in
                                MessageView(message: message)
                                    .id(message.id)
                            }
                            
                            if loadingAnswer {
                                TypingMessageView()
                            }
                            Spacer()
                            
                        }
                        .padding(.top, geo.safeAreaInsets.top)
                        Divider()
                            .frame(height: 52 + geo.safeAreaInsets.bottom + 16)
                            .opacity(0)
                            .id("LoadingMessage")
                    }
                    .scrollDismissesKeyboard(.interactively)
                    .defaultScrollAnchor(.top)
                    
                    inputField
                        .padding(.bottom, geo.safeAreaInsets.bottom + 16)
                }
                .ignoresSafeArea(edges: .vertical)
                .onAppear {
                    proxy.scrollTo("LoadingMessage", anchor: .top)
                }
                .onChange(of: viewModel.messages.count) {
                    withAnimation {
                        proxy.scrollTo("LoadingMessage", anchor: .bottom)
                    }
                }
                .onChange(of: loadingAnswer) {
                    withAnimation {
                        proxy.scrollTo("LoadingMessage", anchor: .bottom)
                    }
                }
                
            }
        }
    }
    
    private var inputField: some View {
        HStack(spacing: 6) {
            TextField("Enter message", text: $text)
                .lineLimit(0)
                .padding(.horizontal)
                .frame(height: 32)
                .multilineTextAlignment(.leading)
                .multilineTextAlignment(
                    strategy: .layoutBased
                )
                .frame(maxHeight: 52)
                .glassEffect()
            
            Button {
                sendMessage()
            } label: {
                Image(systemName: "location.north.fill")
                    .foregroundStyle(.green)
                    .rotationEffect(.degrees(90), anchor: .center)
                    .padding()
            }
            .glassEffect()
        }
        .padding(.horizontal, 24)
    }
    
    func sendMessage() {
        guard !text.isEmpty else { return }
        viewModel.add(text)
        text = ""
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.loadingAnswer = true
        }
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            withAnimation {
//                let newMessage = Messagea(content: "Not able to understand", isCurrentUser: false)
//                messages.append(newMessage)
                self.loadingAnswer = false
            }
        }
    }

}
