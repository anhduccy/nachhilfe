//
//  ExamListItem.swift
//  nachhilfe
//
//  Created by anh :) on 10.09.22.
//

import SwiftUI
import RealmSwift

struct ExamListItem: View {
	@Environment(\.colorScheme) var appearance
	@Binding var selectedExam: Exam?
	@ObservedRealmObject var exam: Exam
	@Binding var showExamEditView: Bool
	let all: Bool
	
	var dateFormatter: DateFormatter {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd.MM.YYYY"
		dateFormatter.locale = Locale(identifier: "de_DE")
		return dateFormatter
	}
	
	var body: some View {
		ZStack{
			if selectedExam?._id == exam._id && showExamEditView{
				RoundedRectangle(cornerRadius: 10)
					.foregroundColor(exam.student.first!.color.color)
					.opacity(0.1)
					.shadow(radius: 1.5)
			} else{
				RoundedRectangle(cornerRadius: 10)
					.fill(appearance == .dark ? Color.init(red: 30/255, green: 30/255, blue: 30/255) : Color.white)
					.shadow(radius: 1.5)
			}
			
			HStack(spacing: 20){
				HStack(spacing: 7.5){
					Text(dateFormatter.string(from: exam.date))
					if all{
						Text((exam.student.first?.surname ?? "Klausur") + " " + (exam.student.first?.name ?? "gelöscht"))
							.foregroundColor(exam.student.first?.color.color ?? .teal)
					}
					if !exam.topics.isEmpty{
						Image(systemName: "note.text")
							.foregroundColor(.gray)
					}
				}.font(.body.bold())
				Spacer()
				if exam.grade == -1{
					Text("--").font(.title.weight(.heavy))
						.foregroundColor(exam.student.first?.color.color ?? .teal)
						.opacity(0.5)
				} else {
					Text("\(exam.grade)")
						.font(.title.weight(.heavy))
						.foregroundColor(exam.student.first?.color.color ?? .teal)
						.opacity(0.5)
				}
			}.padding([.top, .bottom], 10)
				.padding([.leading, .trailing])
		}.fixedSize(horizontal: false, vertical: true)
	}
}

