//
//  StudentLessonList.swift
//  nachhilfe
//
//  Created by anh :) on 07.08.23.
//

import SwiftUI
import RealmSwift

struct StudentLessonList: View{
    @EnvironmentObject var globalVC: GlobalVC
    @ObservedRealmObject var student: Student

    let geo: GeometryProxy
    @Binding var editViewType: EditViewTypes
    @Binding var showAllLessons: Bool
    @Binding var showLessonEditView: Bool

    var body: some View{
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
                            LessonListItem(lesson: lesson, showLessonEditView: $showLessonEditView, all: false)
                                .onTapGesture {
                                    withAnimation{
                                        globalVC.setSelectedLesson(with: lesson)
                                        editViewType = .edit
                                        showLessonEditView = true
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
    private func lessons()->Results<Lesson>{
        var studentLessons = student.lessons.sorted(byKeyPath: "date", ascending: false)
        if showAllLessons {
            return studentLessons.filter(NSPredicate(value: true))
        } else {
            studentLessons = student.lessons.sorted(byKeyPath: "date", ascending: true)
            return studentLessons.filter("isPayed == false || isDone == false")
        }
    }
}


