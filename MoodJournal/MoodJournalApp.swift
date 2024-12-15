//
//  MoodJournalApp.swift
//  MoodJournal
//
//  Created by Brenda Pham on 11/16/24.
//

import SwiftUI

@main
struct MoodJournalApp: App {
    let persistenceController = PersistenceController.shared
    
    @StateObject var journalVM = JournalViewModel(container: PersistenceController.shared.container)
    @StateObject var journalEntryVM = JournalEntryViewModel(container: PersistenceController.shared.container)
    @StateObject var goalVM = GoalViewModel(container: PersistenceController.shared.container)
    @StateObject var moodVM = MoodViewModel(container: PersistenceController.shared.container)
    @StateObject var dailyMoodVM = DailyMoodViewModel(container: PersistenceController.shared.container)
    
    init() {
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().backgroundColor = UIColor(named: "Pink3")
    }

    var body: some Scene {
        
        WindowGroup {
            NavigationView {
                TabView {
                    HomepageView()
                        .tabItem { Label("Home", systemImage: "house.fill") }
                    CalendarView()
                        .tabItem { Label("Calendar", systemImage: "calendar") }
                    NewEntryView()
                        .tabItem { Label("New Entry", systemImage: "plus.circle.fill") }
                    MyJournalsView()
                        .tabItem { Label("My Journals", systemImage: "books.vertical.fill") }
                }
            }.environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(journalVM)
                .environmentObject(journalEntryVM)
                .environmentObject(goalVM)
                .environmentObject(moodVM)
                .environmentObject(dailyMoodVM)
        }
    }
}
