//
//  ExamListItem.swift
//  nachhilfe
//
//  Created by anh :) on 10.09.22.
//

import SwiftUI
import RealmSwift

struct ExamListItem: View {
	@EnvironmentObject var globalVC: GlobalVC
	@Environment(\.colorScheme) var appearance
	@ObservedRealmObject var exam: Exam
	@Binding var isPresented: Bool
	let all: Bool
	
	var dateFormatter: DateFormatter {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd.MM.YYYY"
		dateFormatter.locale = Locale(identifier: "de_DE")
		return dateFormatter
	}
	
	var body: some View {
		ZStack{
			if globalVC.selectedExam?._id == exam._id && isPresented{
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
				HStack(spacing: 5){
					Text(dateFormatter.string(from: exam.date))
					Text("\(exam._id)")
					if !exam.topics.isEmpty{
						Image(systemName: "text.alignleft")
							.font(.footnote)
							.foregroundColor(.gray)
					}
				}.font(.callout.bold())
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

