//
//  CoreDataMessageCRUDHandler.swift
//  crew_chatbot
//
//  Created by Sanju on 04/01/26.
//

import CoreData


typealias MessageUpdateAction = ([Message]) -> Void

protocol MessageCrudHandler: AnyObject {
    var onMessagesUpadte: MessageUpdateAction? { get set }

    @discardableResult
    func add(_ text: String, type: SenderType) -> Bool
    
    @discardableResult
    func sendFileMessage(path: String, size: Int64, thumbPath: String) -> Bool
    
    func getMessages() -> [Message]
}

enum SenderType: String {
    case user
    case agent
}

final class CoreDataMessageCrudHandler: NSObject, MessageCrudHandler {

    var onMessagesUpadte: MessageUpdateAction?

    private let controller: ChatPersistantController = ChatPersistantController.shared
    private let chat: Chat
    
    private var fetchedResultsController: NSFetchedResultsController<Message>?
    
    init(chat: Chat) {
        self.chat = chat
        super.init()
        setupFetchedResultsController()
    }
    
    private func setupFetchedResultsController() {
        let request: NSFetchRequest<Message> = Message.fetchRequest()
        
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Message.timestamp, ascending: true)]
        
        request.predicate = NSPredicate(format: "chat == %@", chat)
        
        request.fetchBatchSize = 25
        
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: controller.container.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        fetchedResultsController?.delegate = self
        
        do {
            try fetchedResultsController?.performFetch()
            let messages = fetchedResultsController?.fetchedObjects ?? []
            onMessagesUpadte?(messages)
        } catch {
            print("Failed to fetch messages: \(error)")
        }
    }
    
    func getMessages() -> [Message] {
        try? fetchedResultsController?.performFetch()
        return fetchedResultsController?.fetchedObjects ?? []
    }
    
    func add(_ text: String, type: SenderType = .user) -> Bool {
        let newMessage = Message(context: controller.container.viewContext)
        newMessage.id = UUID()
        newMessage.text = text
        newMessage.timestamp = Date()
        newMessage.senderValue = type.rawValue
        newMessage.typeValue = "text"
        
        newMessage.chat = chat
        
        chat.lastMessage = text
        chat.lastMessageTimestamp = Date()
        chat.updatedAt = Date()
        
        return saveContext()
    }
    
    func sendFileMessage(path: String, size: Int64, thumbPath: String) -> Bool {
        let newMessage = Message(context: controller.container.viewContext)
        newMessage.id = UUID()
        newMessage.typeValue = "file"
        newMessage.timestamp = Date()
        newMessage.chat = chat
        
        // Create the FileAttachment entity
        let fileMeta = FileAttachment(context: controller.container.viewContext)
        fileMeta.path = path
        fileMeta.fileSize = size
        fileMeta.thumbnailPath = thumbPath
        newMessage.file = fileMeta
        
        return saveContext()
    }
    
    @discardableResult
    private func saveContext() -> Bool {
        if controller.container.viewContext.hasChanges {
            do {
                try controller.container.viewContext.save()
            } catch {
                print("Error saving message: \(error)")
                return false
            }
        }
        
        return true
    }
}

extension CoreDataMessageCrudHandler: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(
        _ controller: NSFetchedResultsController<any NSFetchRequestResult>
    ) {
        if let newMessages = controller.fetchedObjects as? [Message] {
            onMessagesUpadte?(newMessages)
        }
    }
}
