//
//  FileAttachment+CoreDataProperties.swift
//  crew_chatbot
//
//  Created by Sanju on 04/01/26.
//
//

public import Foundation
public import CoreData


public typealias FileAttachmentCoreDataPropertiesSet = NSSet

extension FileAttachment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FileAttachment> {
        return NSFetchRequest<FileAttachment>(entityName: "FileAttachment")
    }

    @NSManaged public var fileSize: Int64
    @NSManaged public var path: String?
    @NSManaged public var thumbnailPath: String?
    @NSManaged public var message: Message?

}

extension FileAttachment : Identifiable {

}
