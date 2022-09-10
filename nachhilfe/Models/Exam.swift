//
//  Exam.swift
//  nachhilfe
//
//  Created by anh :) on 09.08.22.
//

import Foundation
import RealmSwift

class Exam: Object, ObjectKeyIdentifiable{
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted(originProperty: "exams") var student: LinkingObjects<Student>
    @Persisted var topics: String
    @Persisted var date: Date
    @Persisted var grade: Int
	
	static func add(model: ExamModel){
		try! realmEnv.write{
			let student: Student = realmEnv.objects(Student.self).filter("_id == %@", model.student._id).first!
			model.date = setExamDate(model.date)
			student.exams.append(model.toRealm(exam: Exam()))
		}
	}
	static func update(exam: ObservedRealmObject<Exam>.Wrapper, model: ExamModel){
		if exam.wrappedValue.student.first!._id == model.student._id{
			exam.date.wrappedValue = setExamDate(model.date)
			exam.grade.wrappedValue = model.grade
			exam.topics.wrappedValue = model.topics
		} else {
			try! realmEnv.write{
				let store = Exam(value: exam.wrappedValue)
				realmEnv.delete(realmEnv.objects(Exam.self).filter("_id == %@", exam.wrappedValue._id))
				let student = realmEnv.objects(Student.self).filter("_id == %@", model.student._id).first!
				ObservedRealmObject(wrappedValue: student).projectedValue.exams.append(model.toRealm(exam: store))
			}
		}
	}
	static func delete(exam: Exam){
		try! realmEnv.write{
			realmEnv.delete(realmEnv.objects(Exam.self).filter("_id == %@", exam._id))
		}
	}
	static func setExamDate(_ date: Date)->Date{
		let startOfDate = Calendar.current.startOfDay(for: date)
		let newDate = startOfDate.addingTimeInterval(86399)
		return newDate
	}
}

class ExamModel: ObservableObject{
    init(){
		self._id = ObjectId()
		self.topics = ""
		self.date = Date()
		self.grade = -1
		self.student = Student()
    }
    @Published var _id: ObjectId
	@Published var topics: String
	@Published var date: Date
	@Published var grade: Int
	@Published var student: Student
	
	func toLayer(exam: Exam)->ExamModel{
		_id = exam._id
		topics = exam.topics
		date = exam.date
		grade = exam.grade
		student = exam.student.first ?? Student()
		return self
	}
	func toRealm(exam: Exam)->Exam{
		exam.topics = topics
		exam.date = date
		exam.grade = grade
		return exam
	}
}
