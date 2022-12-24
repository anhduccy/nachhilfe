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

    @State var selectedLesson: Lesson? = nil
    @State var showLessonEditView: Bool = false
    @State var editViewType: EditViewTypes = .add
    @State var showStudentEditView: Bool = false
    
    @State var showAllLessons: Bool = false
        
    var body: some View{
        HStack{
            GeometryReader{ geo in
                VStack(spacing: 15){
                    HStack{
                        ViewHeader("\(student.surname) \(student.name)", color: student.color.color){
                            selectedLesson = nil
                            editViewType = .add
                            showLessonEditView = true
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
                        VStack{
                            if !student.lessons.filter("date<%@", Date() as CVarArg).isEmpty{
                                LessonCard(title: "Letzte Nachhilfestunde", lesson: student.lessons.sorted(byKeyPath: "date", ascending: false).filter("date<%@", Date() as CVarArg).first!, selectedLesson: $selectedLesson, showLessonEditView: $showLessonEditView, width: geo.size.width/2, height: 135)
                                    .onTapGesture {
                                        withAnimation{
                                            selectedLesson = student.lessons.sorted(byKeyPath: "date", ascending: false).filter("date<%@", Date() as CVarArg).first!
                                            
                                            editViewType = .edit
                                            showLessonEditView = true
                                        }
                                    }
                            }
                            if !student.lessons.filter("date>%@", Date() as CVarArg).isEmpty{
                                LessonCard(title: "Nächste Nachhilfestunde", lesson: student.lessons.filter("date>%@", Date() as CVarArg).first!, selectedLesson: $selectedLesson, showLessonEditView: $showLessonEditView, width: geo.size.width/2, height: 135)
                                    .onTapGesture {
                                        withAnimation{
                                            selectedLesson = student.lessons.sorted(byKeyPath: "date", ascending: false).filter("date>%@", Date() as CVarArg).first!
                                            
                                            editViewType = .edit
                                            showLessonEditView = true
                                        }
                                    }
                            }
                            Spacer()
                        }.frame(width: geo.size.width/2)
                        
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

