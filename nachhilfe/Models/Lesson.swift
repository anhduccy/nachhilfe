//
//  Lesson.swift
//  nachhilfe
//
//  Created by anh :) on 09.08.22.
//

import Foundation
import RealmSwift

class Lesson: Object, ObjectKeyIdentifiable{
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted(originProperty: "lessons") var student: LinkingObjects<Student>
    @Persisted var date: Date
    @Persisted var duration: Int
    @Persisted var isDone: Bool
    @Persisted var isPayed: Bool
    @Persisted var content: String
    @Persisted var notes: String
    
    static func add(student: Student, model: LessonModel){
        try? realmEnv.write{
            let student: Student = realmEnv.objects(Student.self).filter("_id == %@", student._id).first!
            student.lessons.append(model.toRealm(lesson: Lesson()))
        }
    }
    
    static func update(student: Student, lesson: ObservedRealmObject<Lesson>.Wrapper, model: LessonModel){
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
        realmEnv.delete(lesson)
    }
}

class LessonModel: ObservableObject{
    init(){
        self._id = ObjectId()
        self.date = Date()
        self.duration = 60
        self.isDone = false
        self.isPayed = false
        self.content = ""
        self.notes = ""
        self.student = Student()
    }
    @Published var _id: ObjectId
    @Published var date: Date
    @Published var duration: Int
    @Published var isDone: Bool
    @Published var isPayed: Bool
    @Published var content: String
    @Published var notes: String
    @Published var student: Student
    
    func toLayer(lesson: Lesson)->LessonModel{
        _id = lesson._id
        date = lesson.date
        duration = lesson.duration
        isDone = lesson.isDone
        isPayed = lesson.isPayed
        content = lesson.content
        notes = lesson.notes
        student = lesson.student.first ?? Student()
        return self
    }
    
    func toRealm(lesson: Lesson)->Lesson{
        lesson.date = date
        lesson.duration = duration
        lesson.isDone = isDone
        lesson.isPayed = isPayed
        lesson.content = content
        lesson.notes = notes
        return lesson
    }
}
