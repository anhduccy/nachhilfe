//
//  ExamView.swift
//  nachhilfe
//
//  Created by anh :) on 10.09.22.
//

import SwiftUI
import RealmSwift

struct ExamView: View {
	@EnvironmentObject var globalVC: GlobalVC
	@State var showExamEditView: Bool = false
	@State var editViewType: EditViewTypes = .add
	var body: some View {
		ZStack{
			HStack{
				VStack{
					ViewHeader("Klassenarbeiten & Klausuren"){
						globalVC.setSelectedExam(with: nil)
						editViewType = .add
						showExamEditView = true
					}
					ExamList(showExamEditView: $showExamEditView, editViewType: $editViewType)
					Spacer()
				}.padding()
				if showExamEditView{
					Divider()
					ExamEditView(type: editViewType, exam: globalVC.selectedExam, isPresented:  $showExamEditView)
						.frame(width: 350)
					 
				}
			}
		}
	}
}
