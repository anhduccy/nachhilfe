//
//  Student.swift
//  nachhilfe
//
//  Created by anh :) on 09.08.22.
//

import SwiftUI
import RealmSwift

class StudentLayer: ObservableObject{
    init(){
        surname = ""
        name = ""
        schoolClass = ""
        payment = 0
        color = .teal
    }
    @Published var surname: String
    @Published var name: String
    @Published var schoolClass: String
    @Published var payment: Int
    @Published var color: Student.Colors
}

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
}


