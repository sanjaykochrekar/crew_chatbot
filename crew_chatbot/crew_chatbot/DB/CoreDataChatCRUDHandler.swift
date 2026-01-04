//
//  CoreDataChatCRUDHandler.swift
//  crew_chatbot
//
//  Created by Sanju on 04/01/26.
//

import CoreData

typealias ChatUpdateAction = ([Chat]) -> Void

protocol ChatCRUDHandler: AnyObject {
    var onUpdateChat: ChatUpdateAction? { get set }
    
    @discardableResult
    func delete(chat: Chat) -> Bool
    
    @discardableResult
    func createChat(title: String) -> Chat?
    
    func getChats() -> [Chat]
}


final class CoreDataChatCRUDHandler: NSObject, ChatCRUDHandler, NSFetchedResultsControllerDelegate {
    private let controller: ChatPersistantController = ChatPersistantController.shared
    private let fetchedResultsController: NSFetchedResultsController<Chat>
    var onUpdateChat: ChatUpdateAction?
    
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
    }
    
    
    func delete(chat: Chat) -> Bool {
        let context = chat.managedObjectContext
        context?.delete(chat)
        
        do {
            try context?.save()
        } catch {
            return false
        }
        
        return true
    }
    
    func getChats() -> [Chat] {
        try? fetchedResultsController.performFetch()
        return fetchedResultsController.fetchedObjects ?? []
    }

    func createChat(title: String) -> Chat? {
        let chat = Chat(context: controller.container.viewContext)
        chat.id = UUID()
        chat.title = title
        chat.lastMessage = "Start of a new conversation"
        chat.lastMessageTimestamp = Date()
        chat.createdAt = Date()
        chat.updatedAt = Date()
        
        guard let _ = try? controller.container.viewContext.save() else {
            return nil
        }
        return chat
    }
    
    
    func controllerDidChangeContent(
        _ controller: NSFetchedResultsController<any NSFetchRequestResult>
    ) {
        if let updatedChats = controller.fetchedObjects as? [Chat] {
            onUpdateChat?(updatedChats)
        }
    }
}
