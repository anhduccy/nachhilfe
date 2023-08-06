//
//  StudentOverview.swift
//  nachhilfe
//
//  Created by anh :) on 07.08.23.
//

import SwiftUI
import Charts
import RealmSwift

struct StudentOverview: View{
    @EnvironmentObject var globalVC: GlobalVC
    @ObservedRealmObject var student: Student
    
    let geo: GeometryProxy
    @Binding var editViewType: EditViewTypes
    @Binding var showLessonEditView: Bool
    @Binding var showExamEditView: Bool

    
    var body: some View{
        VStack(spacing: 25){
            if !student.exams.isEmpty {
                VStack{
                    if !student.exams.filter("date<%@", Date() as CVarArg).isEmpty{
                        ExamLineGraph(student: student)
                    }
                    if !student.exams.filter("date>%@", Date() as CVarArg).isEmpty{
                        ExamCard(title: "Nächste Klausur", exam: student.exams.sorted(byKeyPath: "date", ascending: false).filter("date>%@", Date() as CVarArg).sorted(byKeyPath: "date", ascending: true).first!, showExamEditView: $showExamEditView, height: 70, color: student.color.color)
                            .onTapGesture{
                                withAnimation{
                                    globalVC.selectedExam  = student.exams.sorted(byKeyPath: "date", ascending: true).filter("date>%@", Date() as CVarArg).first!
                                    editViewType = .edit
                                    showLessonEditView = false
                                    showExamEditView = true
                                }
                            }
                    }
                    if !student.exams.filter("date<%@", Date() as CVarArg).isEmpty{
                        ExamCard(title: "Letzte Klausur", exam: student.exams.sorted(byKeyPath: "date", ascending: false).filter("date<%@", Date() as CVarArg).first!, showExamEditView: $showExamEditView, height: 70, color: .white)
                            .onTapGesture{
                                withAnimation{
                                    globalVC.selectedExam  = student.exams.sorted(byKeyPath: "date", ascending: false).filter("date<%@", Date() as CVarArg).first!
                                    editViewType = .edit
                                    showLessonEditView = false
                                    showExamEditView = true
                                }
                            }
                    }
                }
            }
            
            if !student.lessons.isEmpty {
                VStack{
                    if !student.lessons.filter("date>%@", Date() as CVarArg).isEmpty{
                        LessonCard(title: "Nächste Nachhilfestunde", lesson: student.lessons.filter("date>%@", Date() as CVarArg).sorted(byKeyPath: "date", ascending: true).first!, showLessonEditView: $showLessonEditView, height: 120)
                            .onTapGesture {
                                withAnimation{
                                    globalVC.setSelectedLesson(with: student.lessons.sorted(byKeyPath: "date", ascending: true).filter("date>%@", Date() as CVarArg).first!)
                                    
                                    editViewType = .edit
                                    showLessonEditView = true
                                    showExamEditView = false
                                }
                            }
                    }
                    if !student.lessons.filter("date<%@", Date() as CVarArg).isEmpty{
                        LessonCard(title: "Letzte Nachhilfestunde", lesson: student.lessons.sorted(byKeyPath: "date", ascending: false).filter("date<%@", Date() as CVarArg).first!, showLessonEditView: $showLessonEditView, height: 120)
                            .onTapGesture {
                                withAnimation{
                                    globalVC.setSelectedLesson(with: student.lessons.sorted(byKeyPath: "date", ascending: false).filter("date<%@", Date() as CVarArg).first!)
                                    
                                    editViewType = .edit
                                    showLessonEditView = true
                                    showExamEditView = false
                                }
                            }
                    }
                }
            }
        }.padding([.trailing, .leading], 5)
                .padding([.top, .bottom], 2)
        
    }
}

struct ExamLineGraph: View{
    @Environment(\.colorScheme) var appearance
    
    init(student: Student){
        var array: [Exam] = []
        var index = 0
        for exam in student.exams.filter("date<%@", Date() as CVarArg){
            if index < 5{
                if exam.grade != -1 {
                    array.append(exam)
                }
                index += 1
            }
        }
        self.lastExamResults = array
        self.student = student
    }
    
    let student: Student
    let lastExamResults: [Exam]
    
    var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YYYY"
        dateFormatter.locale = Locale(identifier: "de_DE")
        return dateFormatter
    }
    
    var body: some View{
        ZStack{
            RoundedRectangle(cornerRadius: 10).fill(appearance == .dark ? Color.init(red: 30/255, green: 30/255, blue: 30/255) : .white)
                .opacity(appearance == .dark ? 1 : 0.9)
                .shadow(radius: 1.5)
            
            VStack{
                LeftText("Letzte Klausuren im Überblick", font: .body, fontWeight: .bold)
                    .foregroundColor(student.color.color)
                Chart{
                    ForEach(lastExamResults){ exam in
                        LineMark(x: .value("Klausur am", dateFormatter.string(from: exam.date)),
                                 y: .value("Note", exam.grade))
                        .symbol{
                            Circle()
                                .fill(student.color.color)
                                .frame(width: 10, height: 10)
                        }
                        
                        PointMark(x: .value("Klausur am", dateFormatter.string(from: exam.date)),
                                  y: .value("Note", exam.grade))
                        .opacity(0)
                        .annotation(position: .overlay,
                                    alignment: .bottom,
                                    spacing: 10) {
                            Text("\(exam.grade)")
                                .foregroundColor(student.color.color)
                                .bold()
                        }
                    }
                }.foregroundStyle(student.color.color)
                .chartYScale(domain: 0...15)
            }
            .padding()
        }
    }
}
