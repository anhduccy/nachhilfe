//
//  CalendarGrid.swift
//  nachhilfe
//
//  Created by anh :) on 13.08.23.
//

import SwiftUI
import RealmSwift

struct CalendarGrid: View{
    @EnvironmentObject var globalVC: GlobalVC
    let weekdays: [String] = ["Mo", "Di", "Mi", "Do", "Fr", "Sa", "So"]
    let gridItem: [GridItem] = Array(repeating: GridItem(.flexible()), count: 7)
    
    @Binding var selectedMonth: Int
    @Binding var selectedDate: Date
    
    var body: some View{
        HStack{
            Text(CalendarViewVC.getMonthAndYear(month: selectedMonth))
                .font(.title3.bold())
            Spacer()
            
            Button(action: {
                selectedMonth -= 1
                globalVC.setSelectedLesson(with: nil)
                globalVC.setSelectedExam(with: nil)
                
            }, label: {
                Icon(systemName: "arrow.left", size: 25)
            })
            
            Button(action: {
                selectedMonth += 1
                globalVC.setSelectedLesson(with: nil)
                globalVC.setSelectedExam(with: nil)
            }, label: {
                Icon(systemName: "arrow.right", size: 25)
            })
            
            Button(action: {
                selectedDate = Calendar.current.startOfDay(for: Date())
                globalVC.setSelectedLesson(with: nil)
                globalVC.setSelectedExam(with: nil)
                selectedMonth = 0
            }, label: {
                Icon(systemName: "\(Calendar.current.dateComponents([.day], from: Date()).day ?? 1).square.fill", size: 25)
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
        self.exams = realmEnv.objects(Exam.self).filter("date >= %@ && date <= %@", startOfDay, endOfDay)
    }
    
    @Binding var selectedDate: Date
    let day: Int
    let date: Date
    
    var lessons: Results<Lesson>
    var exams: Results<Exam>

    var body: some View{
        ZStack{
            RoundedRectangle(cornerRadius: 7.5)
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
                        if lessons.count + exams.count > 4 {
                            HStack(spacing: 3){
                                Text("\(lessons.count + exams.count)")
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                                Circle()
                                    .fill(.teal)
                                    .frame(width: 4, height: 4)
                            }
                            
                        } else {
                            Text("")
                                .font(.caption2)
                            ForEach(exams, id: \.self){ exam in
                                Circle()
                                    .fill(exam.student.first?.color.color ?? .teal)
                                    .frame(width: 4, height: 4)
                            }
                            ForEach(lessons, id: \.self){ lesson in
                                Circle()
                                    .fill(lesson.student.first?.color.color ?? .teal)
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
