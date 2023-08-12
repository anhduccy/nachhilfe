//
//  CalendarDetailView.swift
//  nachhilfe
//
//  Created by anh :) on 13.08.23.
//

import SwiftUI
import RealmSwift

struct CalendarDetailView: View{
    @EnvironmentObject var globalVC: GlobalVC
    
    init(selectedDate: Binding<Date>, showLessonEditView: Binding<Bool>, showExamEditView: Binding<Bool>){
        _selectedDate = selectedDate
        _showLessonEditView = showLessonEditView
        _showExamEditView = showExamEditView
        
                
        let startOfDay = Calendar.current.startOfDay(for: selectedDate.wrappedValue)
        var components = DateComponents()
        components.day = 1
        components.second = -1
        let endOfDay = Calendar.current.date(byAdding: components, to: startOfDay)!
                
        self.lessons = realmEnv.objects(Lesson.self).filter("date >= %@ && date <= %@", startOfDay, endOfDay)
        self.exams = realmEnv.objects(Exam.self).filter("date >= %@ && date <= %@", startOfDay, endOfDay)
        
    }
    
    @Binding var selectedDate: Date
    
    let lessons: Results<Lesson>
    let exams: Results<Exam>
    
    @Binding var showLessonEditView: Bool
    @Binding var showExamEditView: Bool
    
    var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YYYY"
        dateFormatter.locale = Locale(identifier: "de_DE")
        return dateFormatter
    }
    
    var body: some View{
        VStack(spacing: 0){
            if !showLessonEditView && !showExamEditView{
                LeftText(dateFormatter.string(from: selectedDate), font: .title3, fontWeight: .bold)
                    .padding([.leading, .trailing, .top])
            } else {
                HStack{
                    Text("Ereignisse")
                        .font(.title3.bold())
                    Spacer()
                    Text("\(lessons.count + exams.count)")
                        .foregroundColor(.gray)
                }.padding(0)
            }
            if lessons.isEmpty{
                Spacer()
                Text("Keine Ereignisse an diesem Tag")
                    .foregroundColor(.gray)
                Spacer()
            } else {
                ScrollView(.vertical, showsIndicators: false){
                    VStack(spacing: 20){
                        VStack{
                            ForEach(exams, id: \.self){ exam in
                                ExamListItem(exam: exam, isPresented: $showExamEditView, dateMode: false)
                                    .onTapGesture{
                                        withAnimation{
                                            globalVC.setSelectedExam(with: exam)
                                            globalVC.setSelectedLesson(with: nil)
                                            showLessonEditView = false
                                            showExamEditView = true
                                        }
                                    }
                            }
                        }
                        
                        VStack{
                            ForEach(lessons, id: \.self){ lesson in
                                LessonListItem(lesson: lesson, showLessonEditView: $showLessonEditView, dateMode: false)
                                    .onTapGesture{
                                        withAnimation{
                                            globalVC.setSelectedLesson(with: lesson)
                                            globalVC.setSelectedExam(with: nil)
                                            showExamEditView = false
                                            showLessonEditView = true
                                        }
                                    }
                            }
                        }
                    }
                }.padding([.leading, .trailing])
            }
        }
    }
}
