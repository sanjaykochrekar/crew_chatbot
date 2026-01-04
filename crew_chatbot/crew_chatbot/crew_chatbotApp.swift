//
//  crew_chatbotApp.swift
//  crew_chatbot
//
//  Created by Sanju on 04/01/26.
//

import SwiftUI
import CoreData

@main
struct crew_chatbotApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(
                    \.managedObjectContext,
                     ChatPersistantController.shared.container.viewContext
                )
        }
    }
}
