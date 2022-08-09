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
    @Persisted var notes: String
    @Persisted var notesGood: String
    @Persisted var notesBad: String
    @Persisted var notesContent: String
}
