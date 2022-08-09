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
}
