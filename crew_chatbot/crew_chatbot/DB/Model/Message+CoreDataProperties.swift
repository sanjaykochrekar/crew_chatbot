//
//  Message+CoreDataProperties.swift
//  crew_chatbot
//
//  Created by Sanju on 04/01/26.
//
//

public import Foundation
public import CoreData


public typealias MessageCoreDataPropertiesSet = NSSet

extension Message {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Message> {
        return NSFetchRequest<Message>(entityName: "Message")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var senderValue: String?
    @NSManaged public var text: String?
    @NSManaged public var timestamp: Date?
    @NSManaged public var typeValue: String?
    @NSManaged public var chat: Chat?
    @NSManaged public var file: FileAttachment?

}

extension Message : Identifiable {

}
