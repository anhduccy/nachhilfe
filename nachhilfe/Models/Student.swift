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
    @Persisted var color: Colors
    @Persisted var lessons: RealmSwift.List<Lesson>
    @Persisted var exams: RealmSwift.List<Exam>
    
    enum Colors: Int, PersistableEnum{
        case pink, red, orange, yellow, green, mint, cyan, teal, blue, indigo, purple, brown, gray, black
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
            case .gray: return .gray
            case .black: return .black
            }
        }
    }
    
    static func add(students: ObservedResults<Student>, model: StudentModel){
        let student = Student()
        student.surname = model.surname
        student.name = model.name
        student.schoolClass = model.schoolClass
        student.payment = model.payment
        student.color = model.color
        students.append(student)
    }
    
    static func update(student: ObservedRealmObject<Student>.Wrapper, model: StudentModel){
        student.surname.wrappedValue = model.surname
        student.name.wrappedValue = model.name
        student.schoolClass.wrappedValue = model.schoolClass
        student.payment.wrappedValue = model.payment
        student.color.wrappedValue = model.color
    }
    static func delete(student: Student){
        let students = realmEnv.objects(Student.self).filter("_id == %@", student._id).first!
        try! realmEnv.write{
            for exam in students.exams{
                print(exam)
                //delete exams
            }
            for lesson in students.lessons{
                print(lesson)
                //delete lessons
            }
            realmEnv.delete(student)
        }
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
    }
    @Published var _id: ObjectId
    @Published var surname: String
    @Published var name: String
    @Published var schoolClass: String
    @Published var payment: Int
    @Published var color: Student.Colors
    
    func toLayer(student: Student)->StudentModel{
        _id = student._id
        surname = student.surname
        name = student.name
        schoolClass = student.schoolClass
        payment = student.payment
        color = student.color
        return self
    }
    func toRealm(student: Student)->Student{
        student.surname = surname
        student.name = name
        student.schoolClass = schoolClass
        student.payment = payment
        student.color = color
        return student
    }
}


