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
					ViewHeader("Nachhilfestunden"){
						selectedLesson = nil
						editViewType = .add
						showLessonEditView = true
					}
					LessonList(selectedLesson: $selectedLesson, showLessonEditView: $showLessonEditView, editViewType: $editViewType, allStudents: true)
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
