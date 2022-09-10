//
//  ExamEditView.swift
//  nachhilfe
//
//  Created by anh :) on 10.09.22.
//

import SwiftUI
import RealmSwift

struct ExamEditView: View {
	init(type: EditViewTypes, exam: Exam?, isPresented: Binding<Bool>){
		_isPresented = isPresented
		self.type = type
		if type == .add{
			self.model = ExamModel()
			self.selectedExam = Exam()
		} else{
			self.model = ExamModel().toLayer(exam: exam!)
			self.selectedExam = exam!
		}
		
	}
	@Environment(\.colorScheme) var appearance
	@Binding var isPresented: Bool
	
    let type: EditViewTypes
	
    @ObservedRealmObject var selectedExam: Exam
	@ObservedObject var model: ExamModel
	
	@ObservedResults(Student.self) var students
	
    
    var body: some View {
		ZStack{
			VStack{
				ScrollView(.vertical, showsIndicators: false){
					
				}
			}
		}
    }
}
