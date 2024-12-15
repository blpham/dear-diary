//
//  JournalsView.swift
//  MoodJournal
//
//  Created by Brenda Pham on 11/30/24.
//

import SwiftUI


struct MyJournalsView: View {

    @EnvironmentObject var journalVM: JournalViewModel
    @State private var isNewJournalPopoverPresented: Bool = false
    
    let numberOfColumn = 2
    let rows = [GridItem(.fixed(50)),GridItem(.fixed(50)),GridItem(.fixed(50)),GridItem(.fixed(50))]
    let space:Float = 10.0
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
        ]
    
    
    var body: some View {
        VStack {
            Text("My Journals")
                .font(.system(size: 36))
                .fontWidth(.expanded)
                .fontWeight(.heavy)
                .foregroundStyle(Color("Brown"))
                .padding(.top, 20)

            ScrollView {
                LazyVGrid(columns: columns, spacing: 60 , content: {
                    
                    // New Journal Button
                    Button(action: {
                        // Open NewJournalView Popover
                        self.isNewJournalPopoverPresented = true
                    }, label: {
                        VStack {
                            Image(systemName: "plus.square.dashed")
                                .font(.system(size: 70))
                                .foregroundStyle(Color("WhiteSmoke"))
                                .background(Color("Tan")
                                    .frame(width: 100, height: 100)
                                    .cornerRadius(20)
                                    .shadow(color: .gray, radius: 3, x: 0, y: 0))
                                .padding(.bottom, 20)
                            Text("New Journal")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundStyle(Color("Brown"))
                                .frame(maxWidth: 140)
                        }
                    }).popover(isPresented: $isNewJournalPopoverPresented) {
                        NewJournalView()
                    }
                    
                    
                    ForEach (journalVM.savedEntities) { journal in
                        NavigationLink(
                            destination: JournalView(journal: journal),
                            label: {
                                VStack {
                                    Image(systemName: "book.closed.fill")
                                        .font(.system(size: 70))
                                        .foregroundStyle(Color(uiColor: journal.color))
                                        .padding(.bottom, 5)
                                    Text(journal.name)
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .foregroundStyle(Color("Brown"))
                                        .frame(maxWidth: 140)
                                }.background(Color("WhiteSmoke")
                                    .frame(width: 150, height: 150)
                                    .cornerRadius(20)
                                    .shadow(color: .gray, radius: 3, x: 0, y: 0))
                            }
                        ).padding(.bottom, 30)
                    }
                }).frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 40)
            }.padding(.horizontal)
        }.background(AngularGradient(colors: [Color("Pink3"), Color("Pink2"), Color("Pink1")], center: .topTrailing)
            .frame(width: 500, height: 1000))
    }

    func getColumnWidth(width: Float) -> Float {
        ((width) - ((space)*Float(numberOfColumn-1))) / Float(numberOfColumn)
    }
}

#Preview {
    MyJournalsView()
        .environmentObject(JournalViewModel(container: PersistenceController.shared.container))
}
