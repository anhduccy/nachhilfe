//
//  LessonList.swift
//  nachhilfe
//
//  Created by anh :) on 10.09.22.
//

import SwiftUI
import RealmSwift

//Lesson List with all lessons + student filter option with the "all" case
struct LessonList: View{
    @EnvironmentObject var globalVC: GlobalVC
    @ObservedResults(Lesson.self) var lessons
    
    init(selectedStudent: Student? = nil, showLessonEditView: Binding <Bool>, editViewType: Binding<EditViewTypes>, allStudents: Bool){
        if selectedStudent == nil{
            _selectedStudent = State(wrappedValue: selectedStudent)
        } else {
            _selectedStudent = State(wrappedValue: realmEnv.objects(Student.self).filter("_id == %@", selectedStudent!._id).first!)
        }
        _showLessonEditView = showLessonEditView
        _editViewType = editViewType
        self.allStudents = allStudents
    }
    
    @State var selectedStudent: Student?
    @Binding var showLessonEditView: Bool
    @Binding var editViewType: EditViewTypes
    let allStudents: Bool

    @State var showAllLessons: Bool = false
    
    var body: some View{
        VStack {
            HStack(spacing: 12.5){
                if allStudents {
                    if selectedStudent == nil {
                        Text("Alle")
                            .font(.title3.weight(.bold))
                    } else {
                        Text(selectedStudent!.surname + " " + selectedStudent!.name)
                            .font(.title3.weight(.bold))
                    }
                }
                Spacer()
                Button(action: {
                    withAnimation{
                        showAllLessons.toggle()
                    }
                }, label: {
                    Text(showAllLessons ? "Erledigte ausblenden" : "Alle anzeigen")
                        .font(.body.weight(.regular))
                        .foregroundColor(.teal)
                })
                if allStudents{
                    StudentPickerSmall(selectedStudent: $selectedStudent)
                }
            }.padding([.leading, .trailing])
                .padding(.bottom, -5)
            
            ScrollView(.vertical, showsIndicators: false){
                VStack(spacing: 10) {
                    if selectedStudent == nil{
                        if lessons.isEmpty{
                            LeftText("Keine Nachhilfestunden eingetragen")
                                .foregroundColor(.gray)
                        } else if lessons.filter("isPayed == false || isDone == false").isEmpty && !showAllLessons{
                            LeftText("Alle Nachhilfestunden erledigt")
                                .foregroundColor(.gray)
                        } else {
                            ForEach(lessons(showAllLessons: showAllLessons), id: \.self){ lesson in
                                LessonListItem(lesson: lesson, showLessonEditView: $showLessonEditView, all: true)
                                    .onTapGesture {
                                        withAnimation{
                                            globalVC.setSelectedLesson(with: lesson)
                                            editViewType = .edit
                                            showLessonEditView = true
                                        }
                                    }
                            }
                        }
                    } else {
                        if selectedStudent!.lessons.isEmpty{
                            LeftText("Keine Nachhilfestunden eingetragen")
                                .foregroundColor(.gray)
                        } else if selectedStudent!.lessons.filter("isPayed == false || isDone == false").isEmpty && !showAllLessons{
                            LeftText("Alle Nachhilfestunden erledigt")
                                .foregroundColor(.gray)
                        } else {
                            ForEach(selectedStudent_lessons(showAllLessons: showAllLessons), id: \.self){ lesson in
                                LessonListItem(lesson: lesson, showLessonEditView: $showLessonEditView, all: false)
                                    .onTapGesture {
                                        withAnimation{
                                            globalVC.setSelectedLesson(with: lesson)
                                            editViewType = .edit
                                            showLessonEditView = true
                                        }
                                    }
                            }
                        }
                    }
                }.padding([.leading, .trailing])
                    .padding([.top, .bottom], 3)
            }
            Spacer()
        }
    }
    private func lessons(showAllLessons: Bool)->Results<Lesson>{
        var lessons = lessons.sorted(byKeyPath: "date", ascending: false)
        if showAllLessons {
            return lessons.filter(NSPredicate(value: true))
        } else {
            lessons = lessons.sorted(byKeyPath: "date", ascending: true)
            return lessons.filter("isPayed == false || isDone == false")
        }
    }
    
    private func selectedStudent_lessons(showAllLessons: Bool) -> Results<Lesson>{
        var lessons = selectedStudent!.lessons.sorted(byKeyPath: "date", ascending: false)
        if showAllLessons {
            return lessons.filter(NSPredicate(value: true))
        } else {
            lessons = selectedStudent!.lessons.sorted(byKeyPath: "date", ascending: true)
            return lessons.filter("isPayed == false || isDone == false")
        }
    }
}
