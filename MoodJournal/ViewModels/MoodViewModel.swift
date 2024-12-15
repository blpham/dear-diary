//
//  MoodViewModel.swift
//  MoodJournal
//
//  Created by Brenda Pham on 12/3/24.
//

import Foundation
import CoreData
import SwiftUI


class MoodViewModel: ObservableObject {
    
    let container: NSPersistentContainer
    @Published var savedEntities: [MoodEntity] = []
    
    init(container: NSPersistentContainer) {
        
        self.container = container
        
        initializeMoods()
        fetchMoods()
    }
    
    func fetchMoods() {
        let request = NSFetchRequest<MoodEntity>(entityName: "MoodEntity")
        let sortDescriptor = NSSortDescriptor(key: "order", ascending: true)
            request.sortDescriptors = [sortDescriptor]
            
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching moods: \(error)")
        }
    }

    func initializeMoods() {
        let request = NSFetchRequest<MoodEntity>(entityName: "MoodEntity")
        request.fetchLimit = 1
        
        do {
            let existingMoods = try container.viewContext.fetch(request)
            if existingMoods.isEmpty {
                let happyIcon = UIImage(named: "HappyIcon")?.pngData()
                let angryIcon = UIImage(named: "AngryIcon")?.pngData()
                let fearfulIcon = UIImage(named: "FearfulIcon")?.pngData()
                let surprisedIcon = UIImage(named: "SurprisedIcon")?.pngData()
                let badIcon = UIImage(named: "BadIcon")?.pngData()
                let sadIcon = UIImage(named: "SadIcon")?.pngData()
                let disgustedIcon = UIImage(named: "DisgustedIcon")?.pngData()
                
                let moodNamesAndIcons = [
                    ("Happy", happyIcon),
                    ("Angry", angryIcon),
                    ("Fearful", fearfulIcon),
                    ("Surprised", surprisedIcon),
                    ("Bad", badIcon),
                    ("Sad", sadIcon),
                    ("Disgusted", disgustedIcon)
                ]
                
                for (index, (name, icon)) in moodNamesAndIcons.enumerated() {
                    let mood = MoodEntity(context: container.viewContext)
                    mood.name = name
                    mood.icon = icon
                    mood.order = Int32(index)
                }
                saveData()
            }
        } catch let error {
            print("Error checking existing moods: \(error)")
        }
    }

    func saveData() {
        do {
            try container.viewContext.save()
            fetchMoods()
        } catch let error {
            print("Error saving data: \(error)")
        }
    }
}
