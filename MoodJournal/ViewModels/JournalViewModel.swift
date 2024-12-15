//
//  JournalViewModel.swift
//  MoodJournal
//
//  Created by Brenda Pham on 12/2/24.
//

import Foundation
import CoreData
import SwiftUI


class JournalViewModel: ObservableObject {
    
    let container: NSPersistentContainer
    @Published var savedEntities: [JournalEntity] = []
    
    init(container: NSPersistentContainer) {
        
        self.container = container
        
        ensureDefaultJournalExists()
        fetchJournals()
    }
    
    func ensureDefaultJournalExists() {
        let request = NSFetchRequest<JournalEntity>(entityName: "JournalEntity")
        request.predicate = NSPredicate(format: "name == %@", "Mood") // Check for "Mood" journal
        
        do {
            let results = try container.viewContext.fetch(request)
            if results.isEmpty { // No "Mood" journal exists
                if let myColor = UIColor(from: Color("Brown")) {
                    print("Converted UIColor: \(myColor)")
                    addJournal(name: "Mood", color: .brown)
                } else {
                    print("Error converting color")
                }
            }
        } catch let error {
            print("Error checking for default journal: \(error)")
        }
    }
        
    func getDefaultJournal() -> JournalEntity? {
        if let defaultJournal = savedEntities.first(where: { $0.name == "Mood" }) {
            return defaultJournal
        }
        return nil
    }
        
    func fetchJournals() {
        let request = NSFetchRequest<JournalEntity>(entityName: "JournalEntity")
            
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching journals: \(error)")
        }
    }
        
    func addJournal(name: String, color: UIColor) {
        let newJournal = JournalEntity(context: container.viewContext)
        newJournal.name = name
        newJournal.color = color
            
        saveData()
        print("New journal created: \(name)")
    }
        
    func updateJournal(entity: JournalEntity, newName: String, newColor: UIColor) {
        entity.name = newName
        entity.color = newColor
        
        saveData()
    }
    
    func deleteJournal(journal: JournalEntity) {
        // Delete all journal entries associated with the journal
        if let entries = journal.journalEntries as? Set<JournalEntryEntity> {
            for entry in entries {
                container.viewContext.delete(entry)
            }
        }
        
        // Delete the journal itself
        container.viewContext.delete(journal)
        
        saveData()
    }

    func saveData() {
        do {
            try container.viewContext.save()
            fetchJournals()
        } catch let error {
            print("Error saving data: \(error)")
        }
    }
}
