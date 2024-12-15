//
//  SelectMoodView.swift
//  MoodJournal
//
//  Created by Brenda Pham on 12/5/24.
//

import SwiftUI


struct SelectMoodView: View {
    
    @EnvironmentObject var dailyMoodVM: DailyMoodViewModel
    @EnvironmentObject var moodVM: MoodViewModel
    
    var date: Date
    
    var body: some View {
        VStack (spacing: 10) {
            HStack {
                Text("today's mood:")
                    .foregroundStyle(Color("Brown"))
                    .font(.title3)
                    .fontWidth(.expanded)
                    .fontWeight(.bold)
                    .padding(.leading, 20)
                Text(dailyMoodVM.loggedMood(for: date)?.name ?? "")
                    .foregroundStyle(dailyMoodVM.moodColor(for: date))
                    .fontWidth(.expanded)
                    .fontWeight(.bold)
                Spacer()
            }.padding(.bottom, 5)
            ScrollView (.horizontal) {
                HStack {
                    ForEach(moodVM.savedEntities) { mood in
                        Button(action: {
                        // Log the mood for the current date
                        dailyMoodVM.logMood(date: date, mood: mood)
                        }, label: {
                            Image(uiImage: UIImage(data: mood.icon!) ?? UIImage(systemName: "photo")!)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50)
                                .opacity(dailyMoodVM.loggedMood(for: date)?.objectID == mood.objectID ? 1.0 : (dailyMoodVM.hasLoggedMood(for: date) ? 0.5 : 1.0))
                        })
                    }
                }.padding(.horizontal)
            }
        }.frame(width: 330, height: 130)
        .background(Color.white
            .cornerRadius(20)
            .shadow(color: .gray, radius: 3, x: 0, y: 0))
        .padding(.top, 20)
        .padding(.bottom, 10)
        .padding(.leading, 40)
        .padding(.trailing, 40)
    }
}

#Preview {
    let date = Date.now
    
    return SelectMoodView(date: date)
        .environmentObject(MoodViewModel(container: PersistenceController.shared.container))
        .environmentObject(DailyMoodViewModel(container: PersistenceController.shared.container))
}
