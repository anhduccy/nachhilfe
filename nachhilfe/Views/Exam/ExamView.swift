//
//  ExamView.swift
//  nachhilfe
//
//  Created by anh :) on 10.09.22.
//

import SwiftUI
import RealmSwift

struct ExamView: View {
	@State var selectedExam: Exam? = nil
	@State var showExamEditView: Bool = false
	@State var editViewType: EditViewTypes = .add
	var body: some View {
		ZStack{
			HStack{
				VStack{
					ViewHeader("Klassenarbeiten & Klausuren"){
						selectedExam = nil
						editViewType = .add
						showExamEditView = true
					}
					ExamList(selectedExam: $selectedExam, showExamEditView: $showExamEditView, editViewType: $editViewType)
					Spacer()
				}.padding()
				if showExamEditView{
					Divider()
					ExamEditView(type: editViewType, exam: selectedExam, isPresented:  $showExamEditView)
						.frame(width: 350)
					 
				}
			}
		}
	}
}
