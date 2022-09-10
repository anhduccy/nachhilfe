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
			student.exams.append(model.toRealm(exam: Exam()))
		}
	}
	static func update(exam: ObservedRealmObject<Exam>.Wrapper, model: ExamModel){
		if exam.wrappedValue.student.first!._id == model.student._id{
			
		} else {
			
		}
	}
	static func delete(){
		
	}
	static func update(lesson: ObservedRealmObject<Lesson>.Wrapper, model: LessonModel){
		if lesson.wrappedValue.student.first!._id == model.student._id{
			lesson.date.wrappedValue = model.date
			lesson.duration.wrappedValue = model.duration
			lesson.isDone.wrappedValue = model.isDone
			lesson.isPayed.wrappedValue = model.isPayed
			lesson.content.wrappedValue = model.content
			lesson.notes.wrappedValue = model.notes
		} else {
			try! realmEnv.write{
				let store = Lesson(value: lesson.wrappedValue)
				realmEnv.delete(realmEnv.objects(Lesson.self).filter("_id == %@", lesson.wrappedValue._id))
				let student = realmEnv.objects(Student.self).filter("_id == %@", model.student._id).first!
				ObservedRealmObject(wrappedValue: student).projectedValue.lessons.append(model.toRealm(lesson: store))
			}
		}
	}
	
	static func delete(lesson: Lesson){
		try! realmEnv.write{
			realmEnv.delete(realmEnv.objects(Lesson.self).filter("_id == %@", lesson._id))
		}
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
		return self
	}
	func toRealm(exam: Exam)->Exam{
		exam.topics = topics
		exam.date = date
		exam.grade = grade
		return exam
	}
}
