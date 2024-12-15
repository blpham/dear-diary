//
//  JournalEntryViewModel.swift
//  MoodJournal
//
//  Created by Brenda Pham on 11/30/24.
//

import Foundation
import CoreData
import RichTextKit
import UIKit

class JournalEntryViewModel: ObservableObject {
    
    let container: NSPersistentContainer
    @Published var savedEntities: [JournalEntryEntity] = []
    
    init(container: NSPersistentContainer) {
        
        self.container = container
        
        fetchJournalEntries()
    }
        
    func fetchJournalEntries() {
        let request = NSFetchRequest<JournalEntryEntity>(entityName: "JournalEntryEntity")
                
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching journal entries: \(error)")
        }
    }
            
    func addJournalEntry(journal: JournalEntity, text: NSAttributedString, context: RichTextContext, date: Date) {

        let newJournalEntry = JournalEntryEntity(context: container.viewContext)
        
        let attributedStringContext = context.attributedString
        
        newJournalEntry.journal = journal
        newJournalEntry.text = text
        newJournalEntry.context = attributedStringContext
        newJournalEntry.date = date
                
        saveData()
        print("New entry added to \(journal) journal.")
    }
    
    func updateJournalEntry(newJournal: JournalEntity, entity: JournalEntryEntity, newText: NSAttributedString, newContext: RichTextContext, newDate: Date) {
        
        let attributedStringContext = newContext.attributedString
        
        entity.journal = newJournal
        entity.text = newText
        entity.context = attributedStringContext
        entity.date = newDate
    }
    
    func deleteJournalEntry(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        let entity = savedEntities[index]
        container.viewContext.delete(entity)
            
        saveData()
    }
        
    func saveData() {
        do {
            try container.viewContext.save()
            fetchJournalEntries()
        } catch let error {
            print("Error saving data: \(error)")
        }
    }
}
