//
//  GoalViewModel.swift
//  MoodJournal
//
//  Created by Brenda Pham on 12/1/24.
//

import Foundation
import CoreData


class GoalViewModel: ObservableObject {
    
    let container: NSPersistentContainer
    @Published var savedEntities: [GoalEntity] = []
    
    init(container: NSPersistentContainer) {
        
        self.container = container
        
        fetchGoals()
    }
        
    func fetchGoals() {
        let request = NSFetchRequest<GoalEntity>(entityName: "GoalEntity")
            
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching goals: \(error)")
        }
    }
        
    func addGoal(isCompleted: Bool, title: String) {
        let newGoal = GoalEntity(context: container.viewContext)
        newGoal.isCompleted = isCompleted
        newGoal.title = title
            
        saveData()
    }
        
    func updateGoal(entity: GoalEntity, newTitle: String) {
        entity.title = newTitle
        
        saveData()
    }
        
    func deleteGoal(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        let entity = savedEntities[index]
        container.viewContext.delete(entity)
            
        saveData()
    }
        
    func saveData() {
        do {
            try container.viewContext.save()
            fetchGoals()
        } catch let error {
            print("Error saving data: \(error)")
        }
    }
}
