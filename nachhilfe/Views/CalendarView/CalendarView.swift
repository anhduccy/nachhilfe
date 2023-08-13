//
//  CalendarView.swift
//  nachhilfe
//
//  Created by anh :) on 10.08.23.
//

import SwiftUI
import RealmSwift

struct CalendarView: View {
    @EnvironmentObject var globalVC: GlobalVC
    
    @State var editViewType: EditViewTypes = .edit
    @State var selectedMonth: Int = 0
    @State var selectedDate: Date = Calendar.current.startOfDay(for: Date())
    
    var body: some View {
        GeometryReader{ geo in
            VStack{
                HStack{
                    HStack{
                        VStack{
                            HStack{
                                ViewHeader("Kalender", hasButton: false){}
                                Spacer()
                            }
                            
                            if !globalVC.showExamEditView && !globalVC.showLessonEditView{
                                CalendarGrid(selectedMonth: $selectedMonth, selectedDate: $selectedDate)
                                Spacer()
                            } else {
                                ScrollView(.vertical, showsIndicators: false){
                                    CalendarGrid(selectedMonth: $selectedMonth, selectedDate: $selectedDate)
                                    CalendarDetailView(type: $editViewType, selectedDate: $selectedDate)
                                    Spacer()
                                }
                            }
                        }.padding([.leading, .trailing, .top])
                    }.frame(width: geo.size.width/2.4)
                    
                    HStack{
                        Divider()
                        if !globalVC.showExamEditView && !globalVC.showLessonEditView{
                            CalendarDetailView(type: $editViewType, selectedDate: $selectedDate)
                        }
                        
                        if globalVC.showLessonEditView{
                            LessonEditView(type: editViewType, lesson: globalVC.selectedLesson)
                        }
                        
                        if globalVC.showExamEditView{
                            ExamEditView(type: editViewType, exam: globalVC.selectedExam)
                        }
                    }
                }
            }
        }.padding()
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
