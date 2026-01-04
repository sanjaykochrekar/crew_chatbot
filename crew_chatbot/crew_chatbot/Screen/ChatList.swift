    //
    //  ChatList.swift
    //  crew_chatbot
    //
    //  Created by Sanju on 04/01/26.
    //

import SwiftUI
import CoreData


struct ChatList: View {
    @State private var showAddChat: Bool = false
    @State private var path = NavigationPath()
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel: ChatListViewModel = ChatListViewModel()
    
    
    var body: some View {
        NavigationStack(path: $path) {
            chatList
        }
        .sheet(isPresented: $showAddChat) {
            NewChatSheet(onAdd: { newChat in
                path.append(newChat)
            })
        }
    }
    
    private var chatList: some View {
        List(viewModel.chats, id: \.self) { chat in
            NavigationLink(value: chat) {
                ChatItemView(chat: chat)
                    .swipeActions(edge: .trailing) {
                        swipeButton(chat)
                    }
            }
        }
        .overlay {
            if viewModel.chats.isEmpty {
                emptyContent
            }
        }
        .listStyle(.plain)
        .navigationTitle("Chats")
        .navigationDestination(for: Chat.self) { chat in
            ChatDetailView(chat: chat)
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle(chat.title ?? "-")
        }
        .toolbar {
            toolBar
        }
    }
    
    @ViewBuilder
    private func swipeButton(_ chat: Chat) -> some View {
        Button(role: .destructive) {
            deleteSpecificChat(chat)
        } label: {
            Label("Delete", systemImage: "trash.fill")
        }
        .tint(.red)
    }
    
    private var emptyContent: some View {
        ContentUnavailableView(
            "No Chats Found",
            systemImage: "paperplane.fill",
            description: Text("Tap the plus button to start a chat.")
        )
    }
    
    @ViewBuilder
    private var toolBar: some View {
        Button {
            showAddChat.toggle()
        } label: {
            Image(systemName: "plus")
                .foregroundStyle(.green)
        }
    }
    
    
    private func deleteChats(offsets: IndexSet) {
        withAnimation {
            offsets.map { viewModel.chats[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                print("Error deleting chat: \(error)")
            }
        }
    }
    
    func deleteSpecificChat(_ chat: Chat) {
        let context = chat.managedObjectContext
        context?.delete(chat)
        
        do {
            try context?.save()
        } catch {
            print("Failed to delete chat: \(error)")
        }
    }
}
