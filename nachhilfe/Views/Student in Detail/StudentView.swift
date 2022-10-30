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
    
    @State var showAllLessons: Bool = false
        
    var body: some View{
        HStack{
            GeometryReader{ geo in
                VStack(spacing: 12.5){
                    ViewHeader("Nachhilfestunden"){
                        selectedLesson = nil
                        editViewType = .add
                        showLessonEditView = true
                    }
                    HStack{
                        VStack{
                            
                        }.frame(width: geo.size.width/2)

                        VStack{
                            HStack{
                                Text("Nachhilfestunden").font(.title3.weight(.bold))
                                Spacer()
                                Button(showAllLessons ? "Erledigte ausblenden" : "Alle anzeigen"){
                                    withAnimation{
                                        showAllLessons.toggle()
                                    }
                                }.foregroundColor(.teal)
                            }
                            
                            ScrollView(.vertical, showsIndicators: false){
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
                                    }
                                }
                            }
                        }.frame(width: geo.size.width/2)
                    }
                }
            }.padding()
            
            if showLessonEditView {
                Divider()
                LessonEditView(type: editViewType, lesson: selectedLesson, isPresented: $showLessonEditView)
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

