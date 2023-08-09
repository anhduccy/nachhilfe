//
//  StudentList.swift
//  nachhilfe
//
//  Created by anh :) on 07.08.23.
//

import SwiftUI
import RealmSwift

struct StudentList: View{
    @Environment(\.colorScheme) var appearance
    @EnvironmentObject var globalVC: GlobalVC
    @ObservedRealmObject var student: Student

    @State var listMode: StudentListTypes = .lessons
    
    let geo: GeometryProxy
    @Binding var editViewType: EditViewTypes
    @Binding var showAll: Bool
    
    @Binding var showLessonEditView: Bool
    @Binding var showExamEditView: Bool

    var body: some View{
        VStack{
            HStack{
                Button(action: {
                    withAnimation{
                        listMode = .lessons
                    }
                }, label: {
                    Text("Nachhilfestunden").font(.title3)
                        .fontWeight(listMode == .lessons ? .bold : .regular)
                }).foregroundColor(listMode == .lessons ? student.color.color : .gray)
                
                Button(action: {
                    withAnimation{
                        listMode = .exams
                    }
                }, label: {
                    Text("Klausuren").font(.title3)
                        .fontWeight(listMode == .exams ? .bold : .regular)
                }).foregroundColor(listMode == .exams ? student.color.color : .gray)
                
                Spacer()
                Button(showAll ? "Erledigte ausblenden" : "Alle anzeigen"){
                    withAnimation{
                        showAll.toggle()
                    }
                }.foregroundColor(student.color.color)
            }
            
            ScrollView(.vertical, showsIndicators: false){
                if listMode == .lessons {
                    VStack{
                        if student.lessons.isEmpty{
                            LeftText("Keine Nachhilfestunden eingetragen")
                                .foregroundColor(.gray)
                        } else if student.lessons.filter("isPayed == false || isDone == false").isEmpty && !showAll{
                            LeftText("Alle Nachhilfestunden erledigt")
                                .foregroundColor(.gray)
                        } else {
                            ForEach(lessons(), id: \.self){ lesson in
                                LessonListItem(lesson: lesson, showLessonEditView: $showLessonEditView, all: false)
                                    .onTapGesture {
                                        withAnimation{
                                            globalVC.setSelectedLesson(with: lesson)
                                            editViewType = .edit
                                            showExamEditView = false
                                            showLessonEditView = true
                                        }
                                    }
                            }
                            .padding([.trailing, .leading], 5)
                                .padding([.top, .bottom], 2)
                        }
                    }
                } else {
                    VStack{
                        if student.exams.isEmpty{
                            LeftText("Keine Klausuren eingetragen")
                                .foregroundColor(.gray)
                        } else if student.exams.filter("date > %@", Date()).isEmpty && !showAll{
                            LeftText("Keine anstehenden Klausuren")
                                .foregroundColor(.gray)
                        } else {
                            ForEach(exams(), id: \.self){ exam in
                                ExamListItem(exam: exam, isPresented: $showExamEditView, all: false)
                                    .onTapGesture {
                                        withAnimation{
                                            globalVC.setSelectedExam(with: exam)
                                            editViewType = .edit
                                            showExamEditView = true
                                            showLessonEditView = false
                                        }
                                    }
                            }
                            .padding([.trailing, .leading], 5)
                                .padding([.top, .bottom], 2)
                        }
                    }
                }
            }
        }
    }
    private func lessons()->Results<Lesson>{
        var studentLessons = student.lessons.sorted(byKeyPath: "date", ascending: false)
        if showAll {
            return studentLessons.filter(NSPredicate(value: true))
        } else {
            studentLessons = student.lessons.sorted(byKeyPath: "date", ascending: true)
            return studentLessons.filter("isPayed == false || isDone == false")
        }
    }
    
    private func exams()->Results<Exam>{
        var studentExams = student.exams.sorted(byKeyPath: "date", ascending: false)
        if showAll {
            return studentExams
        } else {
            studentExams = student.exams.sorted(byKeyPath: "date", ascending: true)
            return studentExams.filter("date > %@", Date())
        }
    }
}


