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
    @State var showLessonEditView: Bool = false
    @State var showExamEditView: Bool = false

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
                                            globalVC.setSelectedLesson(with: nil)
                                            editViewType = .add
                                            showLessonEditView = true
                                        }
                                    }, label: {Label("Nachhilfestunde hinzufügen", systemImage: "clock")})
                                    Button(action: {
                                        withAnimation{
                                            globalVC.setSelectedExam(with: nil)
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
                    
                    if showLessonEditView || showExamEditView {
                        ScrollView(.vertical, showsIndicators: false){
                            VStack{
                                StudentOverview(student: student, geo: geo, editViewType: $editViewType, showLessonEditView: $showLessonEditView, showExamEditView: $showExamEditView)
                                
                                Divider()
                                
                                StudentLessonList(student: student, geo: geo, editViewType: $editViewType, showAllLessons: $showAllLessons, showLessonEditView: $showLessonEditView)
                                    .padding(.top)
                            }
                        }
                    } else {
                        HStack{
                            ScrollView(.vertical, showsIndicators: false){
                                VStack{
                                    StudentOverview(student: student, geo: geo, editViewType: $editViewType, showLessonEditView: $showLessonEditView, showExamEditView: $showExamEditView)
                                        .frame(width: geo.size.width/2)
                                    Spacer()
                                }
                            }
                            
                            StudentLessonList(student: student, geo: geo, editViewType: $editViewType, showAllLessons: $showAllLessons, showLessonEditView: $showLessonEditView)
                                .frame(width: geo.size.width/2.05)
                        }
                    }
                }
            }.padding()
            
            if showLessonEditView {
                Divider()
                LessonEditView(type: editViewType, lesson: globalVC.selectedLesson, student: student, isPresented: $showLessonEditView)
                    .frame(width: 350)
            }
            
            if showExamEditView {
                Divider()
                ExamEditView(type: editViewType, exam: globalVC.selectedExam, student: student, isPresented: $showExamEditView)
                    .frame(width: 350)
            }
        }
    }
}
