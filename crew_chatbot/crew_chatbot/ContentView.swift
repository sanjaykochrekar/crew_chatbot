//
//  ContentView.swift
//  crew_chatbot
//
//  Created by Sanju on 04/01/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ChatList(chatCrudHandler: CoreDataChatCRUDHandler())
            .task {
                if !UserDefaults.standard.bool(forKey: "IS_LOADED") {
                    InitialDBDataSetupHandler().addData()
                    UserDefaults.standard.set(true, forKey: "IS_LOADED")
                }
            }
    }
}

#Preview {
    ContentView()
}
