//
//  StudentView.swift
//  nachhilfe
//
//  Created by anh :) on 29.10.22.
//

import SwiftUI
import RealmSwift

struct StudentView: View{
    @EnvironmentObject var globalVC: GlobalVC
    @ObservedRealmObject var student: Student

    @State var editViewType: EditViewTypes = .add
    @State var showAllLessons: Bool = false

    @State var showStudentEditView: Bool = false

    var body: some View{
        GeometryReader{ geo in
            HStack{
                VStack(spacing: 15){
                    HStack{
                        VStack(spacing: 0){
                            HStack(alignment: .bottom, spacing: 10){
                                Text("Übersicht").font(.system(size: 50).weight(.heavy))
                                Spacer()
                                Menu(content: {
                                    Button(action: {
                                        withAnimation{
                                            globalVC.setSelectedLesson(with: nil, addMode: true)
                                            editViewType = .add
                                        }
                                    }, label: {Label("Nachhilfestunde hinzufügen", systemImage: "clock")})
                                    Button(action: {
                                        withAnimation{
                                            globalVC.setSelectedExam(with: nil, addMode: true)
                                            editViewType = .add
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
                        .sheet(isPresented: $showStudentEditView){
                            StudentEditView(type: .edit, student: student, isPresented: $showStudentEditView)
                        }
                    }
                    
                    if globalVC.showLessonEditView || globalVC.showExamEditView {
                        ScrollView(.vertical, showsIndicators: false){
                            VStack{
                                StudentOverview(student: student, geo: geo, editViewType: $editViewType)
                                
                                Divider()
                                
                                StudentList(student: student, geo: geo, editViewType: $editViewType, showAll: $showAllLessons)
                                    .padding(.top)
                            }
                        }
                    } else {
                        HStack{
                            if !student.lessons.isEmpty || !student.exams.isEmpty{
                                ScrollView(.vertical, showsIndicators: false){
                                    VStack{
                                        StudentOverview(student: student, geo: geo, editViewType: $editViewType)
                                            .frame(width: geo.size.width/2)
                                        Spacer()
                                    }
                                }
                            }
                            
                            StudentList(student: student, geo: geo, editViewType: $editViewType, showAll: $showAllLessons)
                                .frame(width: !student.lessons.isEmpty || !student.exams.isEmpty ? geo.size.width/2.05 : geo.size.width)
                        }
                    }
                }.ignoresSafeArea(.keyboard)
    
                if globalVC.showLessonEditView {
                    Divider()
                    LessonEditView(type: editViewType, lesson: globalVC.selectedLesson, student: student)
                        .frame(width: geo.size.width/2.5)
                }
                
                if globalVC.showExamEditView {
                    Divider()
                    ExamEditView(type: editViewType, exam: globalVC.selectedExam, student: student)
                        .frame(width: geo.size.width/2.5)
                }
            }
        }
        .padding()
    }
}
