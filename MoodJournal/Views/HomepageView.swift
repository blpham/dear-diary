//
//  HomepageView.swift
//  MoodJournal
//
//  Created by Brenda Pham on 11/16/24.
//

import SwiftUI
import HorizonCalendar


struct HomepageView: View {
    
    @EnvironmentObject var journalVM: JournalViewModel
    @EnvironmentObject var journalEntryVM: JournalEntryViewModel
    @EnvironmentObject var goalVM: GoalViewModel
    @EnvironmentObject var moodVM: MoodViewModel
    @EnvironmentObject var dailyMoodVM: DailyMoodViewModel
    
    @State private var userName: String = UserDefaults.standard.string(forKey: userNameKey) ?? ""
    @State private var isShowingNamePrompt = false
    
    @State private var selectedMood: MoodEntity?
    @State private var isNewGoalPopoverPresented: Bool = false
    @State var selectedDate: Date = Date.now
    @State var isEditingDailyMood: Bool = false
    @State private var sheetHeight: CGFloat = .zero
    
    private let calendar: Calendar
    private let visibleDateRange: ClosedRange<Date>
    private let monthsLayout: MonthsLayout
    
    init() {
            self.calendar = Calendar.current
            let startDate = calendar.date(from: DateComponents(year: 2024, month: 12, day: 01))!
            let endDate = calendar.date(from: DateComponents(year: 2024, month: 12, day: 31))!
            self.visibleDateRange = startDate...endDate
            self.monthsLayout = .vertical(options: VerticalMonthsLayoutOptions())
    }
    
    var body: some View {
        VStack(spacing: 10) {
                    Spacer()
                    Text("\(userName.isEmpty ? "Welcome" : "Hello, \(userName)")!")
                        .foregroundStyle(Color("Brown"))
                        .font(.system(size: 36))
                        .fontWidth(.expanded)
                        .fontWeight(.heavy)
                    Text("how are you feeling?")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(Color("Tan"))

            ScrollView {
                // Today's Mood section
                SelectMoodView(date: .now)
                        
                // Goals section
                VStack (spacing: 10) {
                    Text("goals")
                        .foregroundStyle(Color("Brown"))
                        .font(.title3)
                        .fontWidth(.expanded)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 20)
                        .padding(.top, 20)
                            
                    // Goals list
                    List {
                        // New Goal button
                        Button(action: {
                            self.isNewGoalPopoverPresented = true
                        }) {
                            HStack {
                                Image(systemName: "plus")
                                Text("new goal")
                            }.padding(.vertical, 5)
                                .foregroundColor(.gray)
                        }.popover(isPresented: $isNewGoalPopoverPresented) {
                            AddGoalView()
                        }

                        // Goals from DB
                        ForEach(goalVM.savedEntities) { goal in
                            HStack {
                                Button(action: {
                                    goal.isCompleted.toggle()
                                    goalVM.saveData()
                                }) {
                                    Image(systemName: goal.isCompleted ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(goal.isCompleted ? .green : .gray)
                                }
                                Text(goal.title ?? "")
                                    .foregroundStyle(Color("Brown"))
                            }.padding(.vertical, 5)
                        }.onDelete(perform: goalVM.deleteGoal)
                        
                    }.listStyle(.plain)
                    .padding(.bottom, 20)
                    .frame(minHeight: 200, maxHeight: 500)

                }.frame(width: 330)
                .cornerRadius(50)
                .background(Color(.white)
                    .cornerRadius(20)
                    .shadow(color: .gray, radius: 3, x: 0, y: 0))
                .padding(.bottom, 10)
                .padding(.leading, 40)
                .padding(.trailing, 40)
                        
                // Calendar section
                CalendarViewRepresentable(
                    calendar: calendar,
                    visibleDateRange: visibleDateRange,
                    monthsLayout: monthsLayout,
                    dataDependency: nil
                ).days { day in
                    let calendar = Calendar.current
                    if let date = calendar.date(from: day.components) {
                        // Fetch the mood color from the view model
                        let color = dailyMoodVM.moodColor(for: date)
                        Text("\(day.day)")
                            .font(.system(size: 18))
                            .foregroundColor(Color(UIColor.label))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background {
                                Circle()
                                    .fill(color)
                            }
                    } else {
                        // default to a clear background
                        Text("\(day.day)")
                            .font(.system(size: 18))
                            .foregroundColor(Color(UIColor.label))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background {
                                Circle()
                                    .fill(Color.clear)
                            }
                    }
                }.onDaySelection { day in
                    selectedDate = calendar.date(from: day.components)!
                    self.isEditingDailyMood = true
                  }.interMonthSpacing(24)
                  .verticalDayMargin(8)
                  .horizontalDayMargin(8)
                  .monthHeaders({ month in
                      if let result = convertDateToMonthYear(month.description) {
                          Text(result)
                              .foregroundStyle(Color("Brown"))
                              .font(.title3)
                              .fontWidth(.expanded)
                              .fontWeight(.bold)
                              .frame(maxWidth: .infinity, alignment: .leading)
                              .padding(.bottom, 10)
                      }
                  })
                .padding(20)
                .frame(width: 330, height: 320)
                .background(Color(.white)
                    .cornerRadius(20)
                    .shadow(color: .gray, radius: 3, x: 0, y: 0))
                .padding(.bottom, 40)
                
            }
        }.background(AngularGradient(colors: [Color("Pink3"), Color("Pink2"), Color("Pink1")], center: .topTrailing)
            .frame(width: 500, height: 1000))
        .sheet(isPresented: $isEditingDailyMood, onDismiss: {
            
        }, content: {
            VStack {
                SelectMoodView(date: selectedDate)
                    .modifier(GetHeightModifier(height: $sheetHeight))
                    .presentationDetents([.height(sheetHeight)])
            }.background(Color("Tan")
                .frame(width: 500, height: 400))
        })
        .onAppear {
            if userName.isEmpty {
                isShowingNamePrompt = true
            }
        }
        .sheet(isPresented: $isShowingNamePrompt) {
            NamePromptView(userName: $userName)
        }
    }
}

#Preview {
    NavigationView {
        HomepageView()
            .environmentObject(JournalViewModel(container: PersistenceController.shared.container))
            .environmentObject(JournalEntryViewModel(container: PersistenceController.shared.container))
            .environmentObject(GoalViewModel(container: PersistenceController.shared.container))
            .environmentObject(MoodViewModel(container: PersistenceController.shared.container))
            .environmentObject(DailyMoodViewModel(container: PersistenceController.shared.container))
    }
}
