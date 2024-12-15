//
//  JournalView.swift
//  MoodJournal
//
//  Created by Brenda Pham on 11/30/24.
//

import SwiftUI


struct JournalView: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var journalVM: JournalViewModel
    @EnvironmentObject var journalEntryVM: JournalEntryViewModel
    @State private var isEditJournalPopoverPresented: Bool = false
    @State private var showAlert: Bool = false
    
    var journal: JournalEntity
    
    var body: some View {
        VStack {
            Text(journal.name)
                .font(.system(size: 36))
                .fontWidth(.expanded)
                .fontWeight(.heavy)
                .foregroundStyle(Color("Brown"))
                .padding(.top, 20)
                .padding(.bottom, 30)
            
            VStack {
                Image(systemName: "book.closed.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(Color(uiColor: journal.color))
                    .background(Color("WhiteSmoke")
                        .frame(width: 150, height: 150)
                        .cornerRadius(20)
                        .shadow(color: .gray, radius: 3, x: 0, y: 0))
                    .padding(.bottom, 20)
                
                // Journal Actions
                HStack (spacing: 30) {
                    // Edit Journal Button
                    Button(action: {
                        self.isEditJournalPopoverPresented = true
                    }, label: {
                        Text("Edit")
                            .foregroundStyle(Color.white)
                            .fontWeight(.semibold)
                            .background(Color("Pink0")
                                .frame(width: 55, height: 30)
                                .cornerRadius(10))
                    }).padding(.top)
                        .popover(isPresented: $isEditJournalPopoverPresented) {
                            EditJournalView(journal: journal)
                        }
                    // Delete Journal Button
                    Button(action: {
                        showAlert = true
                    }, label: {
                        Image(systemName: "trash.fill")
                            .foregroundStyle(Color("WhiteSmoke"))
                            .fontWeight(.semibold)
                            .background(Color.red
                                .frame(width: 30, height: 30)
                                .cornerRadius(10))
                    }).padding(.top)
                        .alert(Text("Are you sure?"), isPresented: $showAlert) {
                            Button("Delete Journal", role: .destructive) {
                                journalVM.deleteJournal(journal: journal)
                                dismiss()
                            }
                        } message: {
                        Text("Deleting this journal will delete all of its entries.")
                        }
                }.padding(.horizontal, 30)
            }
            
            if journal.journalEntriesArray.isEmpty {
                Spacer()
                Text("This journal is empty!")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(Color("Brown"))
                    .padding(.top, 20)
                Spacer()
            } else {
                HStack {
                    Text("Entries:")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(Color("Brown"))
                    Spacer()
                }.padding(.bottom, -20)
                .padding(.top, 10)
                .padding(.horizontal, 25)
                List {
                    ForEach (journal.journalEntriesArray, id:\.self) { entry in
                        NavigationLink(
                            destination: JournalEntryView(entry: entry),
                            label: {
                                Text(entry.date.formatted())
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .fontWidth(.expanded)
                                    .foregroundStyle(Color("Brown"))
                            }
                        ).padding(.vertical, 10)
                    }.onDelete(perform: journalEntryVM.deleteJournalEntry)
                        .listRowBackground(Color("WhiteSmoke"))
                }.scrollContentBackground(.hidden)
                    .padding(.top, -15)
            }
        }.background(AngularGradient(colors: [Color("Pink3"), Color("Pink2"), Color("Pink1")], center: .topTrailing)
            .frame(width: 500, height: 1000))
    }
}

#Preview {
    // Create a mock journal and entries for the preview
    let journalVM = JournalViewModel(container: PersistenceController.shared.container)
    let journalEntryVM = JournalEntryViewModel(container: PersistenceController.shared.container)
    let mockJournal = JournalEntity(context: journalVM.container.viewContext)
    mockJournal.name = "Mock Journal"
    mockJournal.color = UIColor.purple
        
    journalEntryVM.addJournalEntry(journal: mockJournal, text: NSAttributedString("mock entry 1"), context: .init(), date: .now)
    journalEntryVM.addJournalEntry(journal: mockJournal, text: NSAttributedString("mock entry 2"), context: .init(), date: .now)
    journalEntryVM.addJournalEntry(journal: mockJournal, text: NSAttributedString("mock entry 3"), context: .init(), date: .now)
    journalEntryVM.addJournalEntry(journal: mockJournal, text: NSAttributedString("mock entry 4"), context: .init(), date: .now)

    return JournalView(journal: mockJournal)
        .environmentObject(JournalEntryViewModel(container: PersistenceController.shared.container))
        .environmentObject(JournalViewModel(container: PersistenceController.shared.container))
}
