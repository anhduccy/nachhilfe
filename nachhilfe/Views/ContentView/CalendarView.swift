//
//  CalendarView.swift
//  nachhilfe
//
//  Created by anh :) on 10.08.23.
//

import SwiftUI
import RealmSwift

struct CalendarView: View {
    
    let weekdays: [String] = ["Mo", "Di", "Mi", "Do", "Fr", "Sa", "So"]
    let gridItem: [GridItem] = Array(repeating: GridItem(.flexible()), count: 7)
    
    @State var selectedMonth: Int = 0
    @State var selectedDate: Date = Date()
    
    var body: some View {
        GeometryReader{ geo in
            VStack{
                HStack{
                    ViewHeader("Kalender", hasButton: false){}
                    Spacer()

                }
                
                HStack{
                    VStack{
                        HStack{
                            Text(CalendarViewVC.getMonthAndYear(month: selectedMonth))
                                .font(.title3.bold())
                            Spacer()
                            Button(action: {
                                selectedMonth -= 1
                            }, label: {
                                Icon(systemName: "arrow.left", size: 25)
                            })
                            
                            Button(action: {
                                selectedMonth += 1
                            }, label: {
                                Icon(systemName: "arrow.right", size: 25)
                            })
                        }
                        
                        LazyVGrid(columns: gridItem){
                            ForEach(weekdays, id: \.self){ weekday in
                                Text(weekday)
                            }.foregroundColor(.gray)
                            ForEach(CalendarViewVC.buildCalendar(month: selectedMonth), id: \.self){ day in
                                if day == -1{
                                    RoundedRectangle(cornerRadius: 10)
                                        .opacity(0)
                                } else {
                                    CalendarDay(day: day, month: selectedMonth, selectedDate: $selectedDate)
                                }
                            }
                        }
                        Spacer()
                    }.frame(width: geo.size.width/3)
                        .padding()

                    Divider()
                    
                    Text("DayView + Lesson-/ExamEditView")
                        .frame(width: geo.size.width/3*2)
                }
            }
        }.padding()
    }
}

struct CalendarDay: View{
    init(day: Int, month: Int, selectedDate: Binding<Date>){
        self.day = day
        
        let date = CalendarViewVC.getDate(day: day, month: month)
        
        let startOfDay = Calendar.current.startOfDay(for: date)
        
        self.date = startOfDay
        _selectedDate = selectedDate
        
        var components = DateComponents()
        components.day = 1
        components.second = -1
        let endOfDay = Calendar.current.date(byAdding: components, to: startOfDay)!
                
        self.lessons = realmEnv.objects(Lesson.self).filter("date >= %@ && date <= %@", startOfDay, endOfDay)
    }
    
    @Binding var selectedDate: Date
    let day: Int
    let date: Date
    let lessons: Results<Lesson>

    var body: some View{
        ZStack{
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(selectedDate == date ? .teal : .clear)
                .opacity(0.2)
            VStack(spacing: 0){
                Text("\(day)")
                    .foregroundColor(Calendar.current.isDateInToday(date) || selectedDate == date  ? .teal : .primary)
                
                if lessons.isEmpty{
                    Text("")
                        .font(.caption2)
                } else {
                    HStack(spacing: 2){
                        if lessons.count > 4 {
                            HStack(spacing: 3){
                                Text("\(lessons.count)")
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                                Circle()
                                    .fill(.teal)
                                    .frame(width: 4, height: 4)
                            }
                            
                        } else {
                            Text("")
                                .font(.caption2)
                            ForEach(lessons, id: \.self){ lesson in
                                Circle()
                                    .fill(Calendar.current.isDateInToday(date) ? .white :  lesson.student.first!.color.color)
                                    .frame(width: 4, height: 4)
                            }
                            Text("")
                                .font(.caption2)
                        }
                    }
                }
            }
        }.aspectRatio(1.0, contentMode: .fit)
            .onTapGesture {
                selectedDate = date
            }
    }
}

class CalendarViewVC{
    static func getMonthAndYear(month: Int)->String{
        let currentMonth = Calendar.current.dateComponents([.month], from: Date()).month
        let currentYear = Calendar.current.component(.year, from: Date())
        
        let dateComponents = DateComponents(year: currentYear, month: currentMonth!+month)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM YYYY"
        dateFormatter.locale = Locale(identifier: "de")
        
        return dateFormatter.string(from: date)
    }
    
    static func getDaysOfMonth(month: Int)->Int{
        let currentMonth = Calendar.current.dateComponents([.month], from: Date()).month
        let currentYear = Calendar.current.component(.year, from: Date())
        
        let dateComponents = DateComponents(year: currentYear, month: currentMonth!+month)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!

        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        return numDays
    }
    
    static func getStartWeekdayOfMonth(month: Int)->Int{
        let currentMonth = Calendar.current.dateComponents([.month], from: Date()).month
        let currentYear = Calendar.current.component(.year, from: Date())
        
        let dateComponents = DateComponents(year: currentYear, month: currentMonth!+month)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!
        return calendar.component(.weekday, from: calendar.startOfMonth(date))
    }
    
    static func buildCalendar(month: Int)->[Int]{
        var array: [Int] = []
        var weekday = 0
        if getStartWeekdayOfMonth(month: month) == 1{
            weekday = 7
        } else {
            weekday = getStartWeekdayOfMonth(month: month) - 1
        }
        for _ in 1..<weekday{
            array.append(-1)
        }
        for day in 1...getDaysOfMonth(month: month){
            array.append(day)
        }
        return array
    }
    
    static func getDate(day: Int, month: Int)->Date{
        let currentMonth = Calendar.current.dateComponents([.month], from: Date()).month
        let currentYear = Calendar.current.component(.year, from: Date())
        
        let dateComponents = DateComponents(year: currentYear, month: currentMonth!+month, day: day)
        let calendar = Calendar.current
        return calendar.date(from: dateComponents)!
    }
    
}

extension Calendar {
    func startOfMonth(_ date: Date) -> Date {
        return self.date(from: self.dateComponents([.year, .month], from: date))!
    }
}


struct Calendar_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
