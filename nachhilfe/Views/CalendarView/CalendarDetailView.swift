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
    
    init(type: Binding<EditViewTypes>, selectedDate: Binding<Date>){
        _selectedDate = selectedDate
        _editViewType = type
                
        let startOfDay = Calendar.current.startOfDay(for: selectedDate.wrappedValue)
        var components = DateComponents()
        components.day = 1
        components.second = -1
        let endOfDay = Calendar.current.date(byAdding: components, to: startOfDay)!
                
        self.lessons = realmEnv.objects(Lesson.self).filter("date >= %@ && date <= %@", startOfDay, endOfDay)
        self.exams = realmEnv.objects(Exam.self).filter("date >= %@ && date <= %@", startOfDay, endOfDay)
        
    }
    
    @Binding var selectedDate: Date
    @Binding var editViewType: EditViewTypes
    
    var lessons: Results<Lesson>
    var exams: Results<Exam>
    
    var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YYYY"
        dateFormatter.locale = Locale(identifier: "de_DE")
        return dateFormatter
    }
    
    var body: some View{
        VStack(spacing: 0){
            if !globalVC.showLessonEditView && !globalVC.showExamEditView{
                HStack{
                    Text(dateFormatter.string(from: selectedDate))
                        .font(.title3.bold())
                    Spacer()
                    Menu(content: {
                        Button(action: {
                            withAnimation{
                                editViewType = .add
                                globalVC.setSelectedLesson(with: nil, addMode: true)
                            }
                        }, label: {Label("Nachhilfestunde hinzufügen", systemImage: "clock")})
                        Button(action: {
                            withAnimation{
                                editViewType = .add
                                globalVC.setSelectedExam(with: nil, addMode: true)
                            }
                        }, label: {Label("Klausur hinzufügen", systemImage: "doc")})
                    }, label: {Icon(systemName: "plus", color: .teal)})
                }.padding()
            } else {
                HStack{
                    Text("Ereignisse")
                        .font(.title3.bold())
                    Spacer()
                    Text("\(lessons.count + exams.count)")
                        .foregroundColor(.gray)
                }.padding(.bottom)
            }
            if !lessons.isEmpty && !exams.isEmpty{
                Spacer()
                Text("Keine Nachhilfestunden oder Klausuren an diesem Tag")
                    .foregroundColor(.gray)
                Spacer()
            } else {
                ScrollView(.vertical, showsIndicators: false){
                    VStack(spacing: 20){
                        if !exams.isEmpty{
                            VStack{
                                ForEach(exams, id: \.self){ exam in
                                    ExamListItem(exam: exam, dateMode: false)
                                        .onTapGesture{
                                            withAnimation{
                                                editViewType = .edit
                                                globalVC.setSelectedExam(with: exam)
                                            }
                                        }
                                }
                            }
                        }
                        
                        if !lessons.isEmpty{
                            VStack{
                                ForEach(lessons, id: \.self){ lesson in
                                    LessonListItem(lesson: lesson, dateMode: false)
                                        .onTapGesture{
                                            withAnimation{
                                                editViewType = .edit
                                                globalVC.setSelectedLesson(with: lesson)
                                            }
                                        }
                                }
                            }
                        }
                    }.padding(5)
                }
            }
        }
    }
}
