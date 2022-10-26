//
//  ExamList.swift
//  nachhilfe
//
//  Created by anh :) on 10.09.22.
//

import SwiftUI
import RealmSwift

struct ExamList: View {
	@Binding var selectedExam: Exam?
	@Binding var showExamEditView: Bool
	@Binding var editViewType: EditViewTypes
	
	@ObservedResults(Exam.self, sortDescriptor: SortDescriptor(keyPath: "date", ascending: false)) var exams
	
	@State var selectedStudent: Student? = nil
	
	@State var showAllExams: Bool = false
	
	var body: some View{
		VStack {
			HStack(spacing: 12.5) {
				if selectedStudent == nil{
					Text("Alle").font(.title3.weight(.bold))
				} else {
					Text(selectedStudent!.surname + " " + selectedStudent!.name)
						.font(.title3.weight(.bold))
				}
				Spacer()
				Button(action: {
					withAnimation{
						showAllExams.toggle()
					}
				}, label: {
					Text(showAllExams ? "Erledigte Klausuren ausblenden" : "Alle Klausuren einblenden")
						.font(.body.weight(.regular))
						.foregroundColor(.teal)
				})
				StudentPickerSmall(selectedStudent: $selectedStudent)
			}.padding([.leading, .trailing])
				.padding(.bottom, -5)
			
			ScrollView(.vertical, showsIndicators: false) {
				VStack(spacing: 10) {
					if selectedStudent == nil {
						if exams.isEmpty{
							LeftText("Keine Klausuren eingetragen")
								.foregroundColor(.gray)
						} else if exams.filter(NSPredicate(format: "date > %@ || grade == -1", Date() as CVarArg)).isEmpty && !showAllExams{
							LeftText("Alle Klausuren erledigt")
								.foregroundColor(.gray)
						} else {
							ForEach(showAllExams ? exams.filter(NSPredicate(value: true)) : exams.filter(NSPredicate(format: "date > %@ || grade == -1", Date() as CVarArg)), id: \.self){ exam in
								ExamListItem(selectedExam: $selectedExam, exam: exam, showExamEditView: $showExamEditView, all: true)
									.onTapGesture {
										withAnimation{
											selectedExam = exam
											editViewType = .edit
											showExamEditView = true
										}
									}
							}
						}
					} else {
						if exams.isEmpty{
							LeftText("Keine Klausuren eingetragen")
								.foregroundColor(.gray)
						} else if selectedStudent!.exams.filter(NSPredicate(format: "date > %@ || grade == -1", Date() as CVarArg)).isEmpty && !showAllExams{
							LeftText("Alle Klausuren erledigt")
								.foregroundColor(.gray)
						} else {
							ForEach(showAllExams ? selectedStudent!.exams.filter(NSPredicate(value: true)) : selectedStudent!.exams.filter(NSPredicate(format: "date > %@ || grade == -1", Date() as CVarArg)), id: \.self){ exam in
								ExamListItem(selectedExam: $selectedExam, exam: exam, showExamEditView: $showExamEditView, all: false)
									.onTapGesture {
										withAnimation{
											selectedExam = exam
											editViewType = .edit
											showExamEditView = true
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
