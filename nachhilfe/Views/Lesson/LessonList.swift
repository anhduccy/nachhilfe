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
    @Binding var selectedLesson: Lesson?
    @Binding var showLessonEditView: Bool
    @Binding var editViewType: EditViewTypes

    @ObservedResults(Lesson.self, sortDescriptor: SortDescriptor(keyPath: "date", ascending: false)) var lessons
    @State var selectedStudent: Student? = nil
    
    @State var showAllLessons: Bool = false
    
    var body: some View{
        VStack {
            HStack(spacing: 12.5){
                if selectedStudent == nil {
                    Text("Alle")
                        .font(.title3.weight(.bold))
                } else {
                    Text(selectedStudent!.surname + " " + selectedStudent!.name)
                        .font(.title3.weight(.bold))
                }
                Spacer()
                Button(action: {
                    withAnimation{
                        showAllLessons.toggle()
                    }
                }, label: {
                    Text(showAllLessons ? "Erledigte Stunden ausblenden" : "Alle Stunden einblenden")
                        .font(.body.weight(.regular))
                        .foregroundColor(.teal)
                })
                
                StudentPickerSmall(selectedStudent: $selectedStudent)
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
                            ForEach(showAllLessons ? lessons.filter(NSPredicate(value: true)) : lessons.filter("isPayed == false || isDone == false"), id: \.self){ lesson in
                                LessonListItem(selectedLesson: $selectedLesson, lesson: lesson, showLessonEditView: $showLessonEditView, all: true)
                                    .onTapGesture {
                                        withAnimation{
                                            selectedLesson = lesson
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
                            ForEach(showAllLessons ? selectedStudent!.lessons.filter(NSPredicate(value: true)) : selectedStudent!.lessons.filter("isPayed == false || isDone == false"), id: \.self){ lesson in
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
                }.padding([.leading, .trailing])
                    .padding([.top, .bottom], 3)
            }
            Spacer()
        }
    }
}
