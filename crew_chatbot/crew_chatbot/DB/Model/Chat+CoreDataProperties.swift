//
//  Chat+CoreDataProperties.swift
//  crew_chatbot
//
//  Created by Sanju on 04/01/26.
//
//

public import Foundation
public import CoreData


public typealias ChatCoreDataPropertiesSet = NSSet

extension Chat {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Chat> {
        return NSFetchRequest<Chat>(entityName: "Chat")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var lastMessage: String?
    @NSManaged public var lastMessageTimestamp: Date?
    @NSManaged public var title: String?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var messages: NSSet?

}

// MARK: Generated accessors for messages
extension Chat {

    @objc(addMessagesObject:)
    @NSManaged public func addToMessages(_ value: Message)

    @objc(removeMessagesObject:)
    @NSManaged public func removeFromMessages(_ value: Message)

    @objc(addMessages:)
    @NSManaged public func addToMessages(_ values: NSSet)

    @objc(removeMessages:)
    @NSManaged public func removeFromMessages(_ values: NSSet)

}

extension Chat : Identifiable {

}
