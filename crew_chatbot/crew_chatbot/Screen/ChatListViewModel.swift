//
//  ChatListViewModel.swift
//  crew_chatbot
//
//  Created by Sanju on 04/01/26.
//

import CoreData
import Combine

final class ChatListViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
    @Published var chats: [Chat] = []
    
    private let fetchedResultsController: NSFetchedResultsController<Chat>
    
    override init() {
        let request: NSFetchRequest<Chat> = Chat.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Chat.lastMessageTimestamp, ascending: false)]
        
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: ChatPersistantController.shared.container.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        super.init()
       
        fetchedResultsController.delegate = self
        
            // Initial Fetch
        try? fetchedResultsController.performFetch()
        chats = fetchedResultsController.fetchedObjects ?? []
    }
    

    
    func controllerDidChangeContent(
        _ controller: NSFetchedResultsController<any NSFetchRequestResult>
    ) {
        if let updatedChats = controller.fetchedObjects as? [Chat] {
            self.chats = updatedChats
        }
    }
}
