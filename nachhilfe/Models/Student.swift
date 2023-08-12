//
//  Student.swift
//  nachhilfe
//
//  Created by anh :) on 09.08.22.
//

import SwiftUI
import RealmSwift

class Student: Object, ObjectKeyIdentifiable{
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var surname: String
    @Persisted var name: String
    @Persisted var schoolClass: String
    @Persisted var payment: Int
	@Persisted var weekday: Weekdays
	@Persisted var defaultTime: Date
    @Persisted var color: Colors
    @Persisted var lessons: RealmSwift.List<Lesson>
    @Persisted var exams: RealmSwift.List<Exam>
    
    enum Colors: Int, PersistableEnum{
        case pink, red, orange, yellow, green, mint, cyan, teal, blue, indigo, purple, brown
        var color: Color{
            switch self{
            case .pink: return .pink
            case .red: return .red
            case .orange: return .orange
            case .yellow: return .yellow
            case .green: return .green
            case .mint: return .mint
            case .teal: return .teal
            case .cyan: return .cyan
            case .blue: return .blue
            case .indigo: return .indigo
            case .purple: return .purple
            case .brown: return .brown
            }
        }
    }
	
	enum Weekdays: Int, PersistableEnum{
		case mon, tue, wed, thu, fri, sat, sun
		
		var name: String{
			switch self {
			case .mon: return "Montag"
			case .tue: return "Dienstag"
			case .wed: return "Mittwoch"
			case .thu: return "Donnerstag"
			case .fri: return "Freitag"
			case .sat: return "Samstag"
			case .sun: return "Sonntag"
			}
		}
		var number: Int{
			switch self {
			case .mon: return 2
			case .tue: return 3
			case .wed: return 4
			case .thu: return 5
			case .fri: return 6
			case .sat: return 7
			case .sun: return 1
			}
		}
	}
    
    static func add(students: ObservedResults<Student>, model: StudentModel){
        students.append(model.toRealm(student: Student()))
    }
    
    static func update(student: ObservedRealmObject<Student>.Wrapper, model: StudentModel){
        student.surname.wrappedValue = model.surname
        student.name.wrappedValue = model.name
        student.schoolClass.wrappedValue = model.schoolClass
        student.payment.wrappedValue = model.payment
		student.weekday.wrappedValue = model.weekday
		student.defaultTime.wrappedValue = model.defaultTime
        student.color.wrappedValue = model.color
    }
    static func delete(student: Student){
		if realmEnv.isInWriteTransaction{
			runDelete(student: student)
		} else {
			try! realmEnv.write{
			   runDelete(student: student)
			}
		}
    }
	static func runDelete(student: Student){
		let studentObj = realmEnv.objects(Student.self).filter("_id == %@", student._id).first!
			for exam in studentObj.exams{
				Exam.delete(exam: exam)
			}
			for lesson in studentObj.lessons{
				Lesson.delete(lesson: lesson)
			}
			realmEnv.delete(studentObj)
	}
}

class StudentModel: ObservableObject{
    init(){
        _id = ObjectId()
        surname = ""
        name = ""
        schoolClass = ""
        payment = 0
        color = .teal
		weekday = .mon
		defaultTime = Date().startOfMonth()
    }  
    @Published var _id: ObjectId
    @Published var surname: String
    @Published var name: String
    @Published var schoolClass: String
    @Published var payment: Int
	@Published var weekday: Student.Weekdays
	@Published var defaultTime: Date
    @Published var color: Student.Colors
    
    func toLayer(student: Student)->StudentModel{
        _id = student._id
        surname = student.surname
        name = student.name
        schoolClass = student.schoolClass
		weekday = student.weekday
        payment = student.payment
		defaultTime = student.defaultTime
        color = student.color
        return self
    }
    func toRealm(student: Student)->Student{
        student.surname = surname
        student.name = name
        student.schoolClass = schoolClass
        student.payment = payment
		student.weekday = weekday
		student.defaultTime = defaultTime
        student.color = color
        return student
    }
}


