//
//  StudentView.swift
//  nachhilfe
//
//  Created by anh :) on 29.10.22.
//

import SwiftUI
import RealmSwift
import Realm

struct StudentView: View{
    @ObservedRealmObject var student: Student

    //Lessons
    @State var selectedLesson: Lesson? = nil
    @State var showLessonEditView: Bool = false
    
    //Exams
    @State var selectedExam: Exam? = nil
    @State var showExamEditView: Bool = false
    
    @State var showStudentEditView: Bool = false

    @State var editViewType: EditViewTypes = .add
    @State var showAllLessons: Bool = false
        
    var body: some View{
        HStack{
            GeometryReader{ geo in
                VStack(spacing: 15){
                    HStack{
                        VStack(spacing: 0){
                            HStack(alignment: .bottom, spacing: 10){
                                Text("Übersicht").font(.system(size: 50).weight(.heavy))
                                Spacer()
                                Menu(content: {
                                    Button(action: {
                                        withAnimation{
                                            selectedLesson = nil
                                            editViewType = .add
                                            showLessonEditView = true
                                        }
                                    }, label: {Label("Nachhilfestunde hinzufügen", systemImage: "clock")})
                                    Button(action: {
                                        withAnimation{
                                            selectedExam = nil
                                            editViewType = .add
                                            showExamEditView = true
                                        }
                                    }, label: {Label("Klausur hinzufügen", systemImage: "doc")})
                                }, label: {Icon(systemName: "plus", color: student.color.color)})
                            }
                            LeftText("\(student.surname) \(student.name)", font: .title2, fontWeight: .bold)
                                .foregroundColor(student.color.color)
                        }
                        Button(action: {showStudentEditView.toggle()}, label: {
                            Icon(systemName: "info.circle", color: student.color.color)
                        })
                        .padding([.leading, .trailing], 5)
                        .popover(isPresented: $showStudentEditView){
                            StudentEditView(type: .edit, student: student, isPresented: $showStudentEditView)
                        }
                    }
                    HStack{
                        ScrollView(.vertical, showsIndicators: false){
                            VStack(spacing: 25){
                                if !student.exams.isEmpty {
                                    VStack{
                                        if !student.exams.filter("date>%@", Date() as CVarArg).isEmpty{
                                            ExamCard(title: "Nächste Klausur", exam: student.exams.sorted(byKeyPath: "date", ascending: false).filter("date>%@", Date() as CVarArg).first!, selectedExam: $selectedExam, showExamEditView: $showExamEditView, width: geo.size.width/2, height: 70, color: student.color.color)
                                                .onTapGesture{
                                                    withAnimation{
                                                        selectedExam  = student.exams.sorted(byKeyPath: "date", ascending: false).filter("date>%@", Date() as CVarArg).first!
                                                        editViewType = .edit
                                                        showLessonEditView = false
                                                        showExamEditView = true
                                                    }
                                                }
                                        }
                                        if !student.exams.filter("date<%@", Date() as CVarArg).isEmpty{
                                            ExamCard(title: "Letzte Klausur", exam: student.exams.sorted(byKeyPath: "date", ascending: false).filter("date<%@", Date() as CVarArg).first!, selectedExam: $selectedExam, showExamEditView: $showExamEditView, width: geo.size.width/2, height: 70, color: .white)
                                                .onTapGesture{
                                                    withAnimation{
                                                        selectedExam  = student.exams.sorted(byKeyPath: "date", ascending: false).filter("date<%@", Date() as CVarArg).first!
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
                                            LessonCard(title: "Nächste Nachhilfestunde", lesson: student.lessons.filter("date>%@", Date() as CVarArg).first!, selectedLesson: $selectedLesson, showLessonEditView: $showLessonEditView, width: geo.size.width/2, height: 120)
                                                .onTapGesture {
                                                    withAnimation{
                                                        selectedLesson = student.lessons.sorted(byKeyPath: "date", ascending: true).filter("date>%@", Date() as CVarArg).first!
                                                        
                                                        editViewType = .edit
                                                        showLessonEditView = true
                                                        showExamEditView = false
                                                    }
                                                }
                                        }
                                        if !student.lessons.filter("date<%@", Date() as CVarArg).isEmpty{
                                            LessonCard(title: "Letzte Nachhilfestunde", lesson: student.lessons.sorted(byKeyPath: "date", ascending: false).filter("date<%@", Date() as CVarArg).first!, selectedLesson: $selectedLesson, showLessonEditView: $showLessonEditView, width: geo.size.width/2, height: 120)
                                                .onTapGesture {
                                                    withAnimation{
                                                        selectedLesson = student.lessons.sorted(byKeyPath: "date", ascending: false).filter("date<%@", Date() as CVarArg).first!
                                                        
                                                        editViewType = .edit
                                                        showLessonEditView = true
                                                        showExamEditView = false
                                                    }
                                                }
                                        }
                                    }
                                }
                                
                                Spacer()
                            }.padding([.trailing, .leading], 5)
                                .padding([.top, .bottom], 2)
                        }
                        
                        VStack{
                            HStack{
                                Text("Nachhilfestunden").font(.title3.weight(.bold))
                                Spacer()
                                Button(showAllLessons ? "Erledigte ausblenden" : "Alle anzeigen"){
                                    withAnimation{
                                        showAllLessons.toggle()
                                    }
                                }.foregroundColor(student.color.color)
                            }
                            
                            ScrollView(.vertical, showsIndicators: false){
                                VStack{
                                    if student.lessons.isEmpty{
                                        LeftText("Keine Nachhilfestunden eingetragen")
                                            .foregroundColor(.gray)
                                    } else if student.lessons.filter("isPayed == false || isDone == false").isEmpty && !showAllLessons{
                                        LeftText("Alle Nachhilfestunden erledigt")
                                            .foregroundColor(.gray)
                                    } else {
                                        ForEach(lessons(), id: \.self){ lesson in
                                            LessonListItem(selectedLesson: $selectedLesson, lesson: lesson, showLessonEditView: $showLessonEditView, all: false)
                                                .onTapGesture {
                                                    withAnimation{
                                                        selectedLesson = lesson
                                                        editViewType = .edit
                                                        showLessonEditView = true
                                                    }
                                                }
                                        }.padding([.trailing, .leading], 5)
                                            .padding([.top, .bottom], 2)
                                    }
                                }
                            }
                        }
                        .padding([.leading, .trailing])
                        .frame(width: geo.size.width/2)
                    }
                }
            }.padding()
            
            if showLessonEditView {
                Divider()
                LessonEditView(type: editViewType, lesson: selectedLesson, student: student, isPresented: $showLessonEditView)
                    .frame(width: 350)
            }
            
            if showExamEditView {
                Divider()
                ExamEditView(type: editViewType, exam: selectedExam, student: student, isPresented: $showExamEditView)
                    .frame(width: 350)
            }
        }
    }
    private func lessons()->Results<Lesson>{
        let studentLessons = student.lessons.sorted(byKeyPath: "date", ascending: false)
        if showAllLessons {
            return studentLessons.filter(NSPredicate(value: true))
        } else {
            return studentLessons.filter("isPayed == false || isDone == false")
        }
    }
}

