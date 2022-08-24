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
			HStack{
				VStack{
					VStack(spacing: 0){
						HStack(alignment: .bottom, spacing: 10){
							Text("Übersicht").font(.system(size: 50).weight(.heavy))
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
						LeftText("Nachhilfestunden", font: .title2, fontWeight: .bold)
							.foregroundColor(.teal)
					}
                    HStack{
                        LessonList()
                        
                        //Right: Statistics and Recents
                        
                        //FadeIn: EditView
                    }
                    Spacer()
                }.padding()
                if showLessonEditView {
					Divider()
                    LessonEditView(type: editViewType, lesson: selectedLesson, isPresented: $showLessonEditView)
						.frame(width: 350)
                }
            }
		}
	}
}

//Lesson List with all lessons + student filter option with the "all" case
struct LessonList: View{
    @ObservedResults(Lesson.self) var lessons
    var body: some View{
		ForEach(lessons, id: \.self){ lesson in
			Text(lesson.date.description)
		}
    }
}
