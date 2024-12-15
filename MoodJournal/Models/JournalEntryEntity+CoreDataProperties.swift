//
//  JournalEntity+CoreDataProperties.swift
//  MoodJournal
//
//  Created by Brenda Pham on 12/3/24.
//

import Foundation
import CoreData


extension JournalEntryEntity {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<JournalEntryEntity> {
        return NSFetchRequest<JournalEntryEntity>(entityName: "JournalEntryEntity")
    }
    
    @NSManaged public var date: Date
    @NSManaged public var text: NSAttributedString
    @NSManaged public var context: NSAttributedString
    
    @NSManaged public var journal: JournalEntity
    
}

extension JournalEntryEntity: Identifiable {
    
}

extension JournalEntryEntity {
    
}
