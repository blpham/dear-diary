//
//  JournalEntity+CoreDataProperties.swift
//  MoodJournal
//
//  Created by Brenda Pham on 12/3/24.
//

import Foundation
import CoreData
import UIKit


extension JournalEntity {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<JournalEntity> {
        return NSFetchRequest<JournalEntity>(entityName: "JournalEntity")
    }
    
    @NSManaged public var name: String
    @NSManaged public var color: UIColor
    @NSManaged public var journalEntries: NSSet
    
}

extension JournalEntity: Identifiable {
    
}

extension JournalEntity {
    var journalEntriesArray: [JournalEntryEntity] {
        (journalEntries as? Set<JournalEntryEntity>)?.sorted { $0.date > $1.date } ?? []
    }
}
