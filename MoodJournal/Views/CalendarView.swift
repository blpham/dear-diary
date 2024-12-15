//
//  CalendarView.swift
//  MoodJournal
//
//  Created by Brenda Pham on 11/30/24.
//

import SwiftUI
import HorizonCalendar


struct CalendarView: View {
    
    @EnvironmentObject var dailyMoodVM: DailyMoodViewModel
    @EnvironmentObject var moodVM: MoodViewModel
    
    @State var selectedDate: Date = Date.now
    @State var isEditingDailyMood: Bool = false
    @State private var sheetHeight: CGFloat = .zero
    
    private let calendar: Calendar
    private let visibleDateRange: ClosedRange<Date>
    private let monthsLayout: MonthsLayout
    
    init() {
            self.calendar = Calendar.current
            let startDate = calendar.date(from: DateComponents(year: 2024, month: 11, day: 01))!
            let endDate = calendar.date(from: DateComponents(year: 2025, month: 12, day: 31))!
            self.visibleDateRange = startDate...endDate
            self.monthsLayout = .vertical(options: VerticalMonthsLayoutOptions())
    }
    
    var body: some View {
        VStack {
            Spacer()
            Text("Mood Calendar")
                .foregroundStyle(Color("Brown"))
                .font(.system(size: 36))
                .fontWidth(.expanded)
                .fontWeight(.heavy)
            
            CalendarViewRepresentable(
                calendar: calendar,
                visibleDateRange: visibleDateRange,
                monthsLayout: monthsLayout,
                dataDependency: nil
            ).days { day in
                let calendar = Calendar.current
                if let date = calendar.date(from: day.components) {
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
                    // default to clear background
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
            .frame(width: 330, height: 600)
            .background(Color(.white)
                .cornerRadius(20)
                .shadow(color: .gray, radius: 3, x: 0, y: 0))
            .padding(.bottom, 40)
        }.background(AngularGradient(colors: [Color("Pink3"), Color("Pink2"), Color("Pink1")], center: .topTrailing)
            .frame(width: 500, height: 1000))
        .sheet(isPresented: $isEditingDailyMood, content: {
            VStack {
                SelectMoodView(date: selectedDate)
                    .modifier(GetHeightModifier(height: $sheetHeight))
                    .presentationDetents([.height(sheetHeight)])
            }.background(Color("Tan")
                .frame(width: 500, height: 400))
        })
    }
}

#Preview {
    CalendarView()
        .environmentObject(DailyMoodViewModel(container: PersistenceController.shared.container))
        .environmentObject(MoodViewModel(container: PersistenceController.shared.container))
}
