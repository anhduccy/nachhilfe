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
	@EnvironmentObject var globalVC: GlobalVC
	@State var showLessonEditView: Bool = false
	@State var editViewType: EditViewTypes = .add
	
	var body: some View {
		ZStack{
			HStack{
				VStack{
					ViewHeader("Nachhilfestunden"){
						globalVC.setSelectedLesson(with: nil)
						editViewType = .add
						showLessonEditView = true
					}
					LessonList(showLessonEditView: $showLessonEditView, editViewType: $editViewType, allStudents: true)
					Spacer()
				}.padding()
				if showLessonEditView {
					Divider()
					LessonEditView(type: editViewType, lesson: globalVC.selectedLesson, isPresented: $showLessonEditView)
						.frame(width: 350)
				}
			}
		}
	}
}
