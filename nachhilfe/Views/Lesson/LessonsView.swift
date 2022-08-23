//
//  LessonsView.swift
//  nachhilfe
//
//  Created by anh :) on 14.08.22.
//

import SwiftUI
import Realm
import RealmSwift

struct LessonsView: View {
    @State var selectedLesson: Lesson? = nil
    @State var showLessonEditView: Bool = false
    @State var editViewType: EditViewTypes = .add
    
    var body: some View {
        ZStack{
            VStack{
                HStack(alignment: .bottom, spacing: 10){
                    Text("Übersicht").font(.system(size: 50).weight(.heavy))
                    Text("Nachhilfestunden").font(.title2.weight(.bold))
                        .foregroundColor(.teal)
                    Spacer()
                    Button(action: {
                        withAnimation{
                            selectedLesson = nil
                            editViewType = .add
                            showLessonEditView = true
                        }
                    }, label: {
                        Icon(systemName: "plus")
                    })
                }
                HStack{
                    LessonList()
                    
                    //Right: Statistics and Recents
                    
                    //FadeIn: EditView
                }
                Spacer()
            }
            
            LessonEditView(type: editViewType, lesson: selectedLesson, isPresented: $showLessonEditView)
                .offset(x: showLessonEditView ? 330 : UIScreen().bounds.width+750)
        }
        .padding(.leading, 50)
        .padding(.trailing, 50)
        
    }
}

//Lesson List with all lessons + student filter option with the "all" case
struct LessonList: View{
    @ObservedResults(Lesson.self) var lessons
    var body: some View{
        Text("Alle").font(.title2.weight(.bold)) //Picker-Option
        List{
            ForEach(lessons, id: \.self){ lesson in
                Text(lesson.date.description)
            }
        }
    }
}
