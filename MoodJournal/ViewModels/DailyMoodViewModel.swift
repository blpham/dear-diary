//
//  DailyMoodViewModel.swift
//  MoodJournal
//
//  Created by Brenda Pham on 12/3/24.
//

import Foundation
import CoreData
import SwiftUI


class DailyMoodViewModel: ObservableObject {
    
    enum MoodColor {
        case happy, angry, fearful, surprised, bad, sad, disgusted
            
        var color: Color {
            switch self {
            case .happy: return Color("HappyColor")
            case .angry: return Color("AngryColor")
            case .fearful: return Color("FearfulColor")
            case .surprised: return Color("SurprisedColor")
            case .bad: return Color("BadColor")
            case .sad: return Color("SadColor")
            case .disgusted: return Color("DisgustedColor")
            }
        }
    }
    
    let container: NSPersistentContainer
    @Published var savedEntities: [DailyMoodEntity] = []
    
    init(container: NSPersistentContainer) {
        
        self.container = container
        
        fetchDailyMoods()
    }
    
    func fetchDailyMoods() {
        let request = NSFetchRequest<DailyMoodEntity>(entityName: "DailyMoodEntity")
            
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching daily moods: \(error)")
        }
    }
    
    func isMoodSet(for date: Date) -> Bool {
        let request = NSFetchRequest<DailyMoodEntity>(entityName: "DailyMoodEntity")
            
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!

        request.predicate = NSPredicate(format: "date >= %@ AND date < %@", startOfDay as NSDate, endOfDay as NSDate)
            
        do {
            let result = try container.viewContext.fetch(request)
            return !result.isEmpty
        } catch {
            print("Error checking mood for date: \(error)")
            return false
        }
    }
        
    func logMood(date: Date, mood: MoodEntity) {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
            
        let request = NSFetchRequest<DailyMoodEntity>(entityName: "DailyMoodEntity")
        request.predicate = NSPredicate(format: "date == %@", startOfDay as NSDate)
            
        do {
            let result = try container.viewContext.fetch(request)
            if let existingEntity = result.first {
                // Update existing mood
                existingEntity.mood = mood
                print("\(date.formatted())'s Mood updated to \(mood.name ?? "")")
            } else {
                // Create new DailyMoodEntity
                let newDailyMood = DailyMoodEntity(context: container.viewContext)
                newDailyMood.date = startOfDay
                newDailyMood.mood = mood
                print("Mood set to \(mood.name ?? "")")
            }
            saveData()
        } catch {
            print("Error logging mood: \(error)")
        }
    }
    
    func updateMood(entity: DailyMoodEntity, newMood: MoodEntity) {
        entity.mood = newMood
        
        saveData()
    }
    
    func moodColor(for date: Date) -> Color {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)

        let request = NSFetchRequest<DailyMoodEntity>(entityName: "DailyMoodEntity")
        request.predicate = NSPredicate(format: "date == %@", startOfDay as NSDate)
        
        do {
            let result = try container.viewContext.fetch(request)
            if let dailyMood = result.first, let moodName = dailyMood.mood?.name {
                // Map mood name to MoodColor
                switch moodName {
                case "Happy": return MoodColor.happy.color
                case "Angry": return MoodColor.angry.color
                case "Fearful": return MoodColor.fearful.color
                case "Surprised": return MoodColor.surprised.color
                case "Bad": return MoodColor.bad.color
                case "Sad": return MoodColor.sad.color
                case "Disgusted": return MoodColor.disgusted.color
                default: return .clear
                }
            }
        } catch {
            print("Error fetching mood color for date: \(error)")
        }
        
        return .clear // Default to clear if no mood is logged
    }
    
    func hasLoggedMood(for date: Date) -> Bool {
        let startOfDay = Calendar.current.startOfDay(for: date)
        let request = NSFetchRequest<DailyMoodEntity>(entityName: "DailyMoodEntity")
        request.predicate = NSPredicate(format: "date == %@", startOfDay as NSDate)

        do {
            let result = try container.viewContext.fetch(request)
            return !result.isEmpty
        } catch {
            print("Error checking logged mood: \(error)")
            return false
        }
    }

    func loggedMood(for date: Date) -> MoodEntity? {
        let startOfDay = Calendar.current.startOfDay(for: date)
        let request = NSFetchRequest<DailyMoodEntity>(entityName: "DailyMoodEntity")
        request.predicate = NSPredicate(format: "date == %@", startOfDay as NSDate)

        do {
            let result = try container.viewContext.fetch(request)
            return result.first?.mood
        } catch {
            print("Error fetching logged mood: \(error)")
            return nil
        }
    }
    
    func saveData() {
        do {
            try container.viewContext.save()
            fetchDailyMoods()
        } catch let error {
            print("Error saving data: \(error)")
        }
    }
}
