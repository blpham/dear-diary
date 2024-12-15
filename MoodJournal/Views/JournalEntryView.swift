//
//  JournalEntryView.swift
//  MoodJournal
//
//  Created by Brenda Pham on 11/30/24.
//

import SwiftUI
import RichTextKit


struct JournalEntryView: View {
    
    @EnvironmentObject var journalEntryVM: JournalEntryViewModel
    @State var entry: JournalEntryEntity
    
    var body: some View {
        
        VStack {
            Spacer()
            Text("Journal Entry")
                .font(.title)
                .fontWidth(.expanded)
                .fontWeight(.heavy)
                .foregroundStyle(Color("Brown"))
                .padding(.top, 20)
            
            // Display journal name and date
            HStack {
                Text(entry.journal.name)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(Color("Brown"))
                Spacer()
                Text(entry.date.formatted())
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(Color("Brown"))
            }.padding(.horizontal, 30)
                .padding(.top, 10)
        
            // Display Journal Entry
            RichTextViewer(entry.text)
                .frame(minHeight: 550)
                .frame(maxHeight: .infinity)
                .cornerRadius(10)
                .padding(.horizontal)
                .padding(.top, 10)
                .shadow(color: .gray, radius: 3, x: 0, y: 0)
        }.background(AngularGradient(colors: [Color("Pink3"), Color("Pink2"), Color("Pink1")], center: .topTrailing)
            .frame(width: 500, height: 1000))
    }
}

#Preview {
    let journalVM = JournalViewModel(container: PersistenceController.shared.container)
    let journalEntryVM = JournalEntryViewModel(container: PersistenceController.shared.container)
    let mockJournal = JournalEntity(context: journalVM.container.viewContext)
    mockJournal.name = "Mock Journal"
    let mockEntry = JournalEntryEntity(context: journalVM.container.viewContext)
    mockEntry.text = NSAttributedString("hello world")
    journalEntryVM.addJournalEntry(journal: mockJournal, text: NSAttributedString("hello world"), context: .init(), date: .now)
    
    return JournalEntryView(entry: mockEntry)
}
