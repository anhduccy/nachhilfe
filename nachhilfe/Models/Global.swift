//
//  Global.swift
//  nachhilfe
//
//  Created by anh :) on 09.08.22.
//

import Foundation
import SwiftUI

class Global: ObservableObject{
    init(){
        username = ""
    }
    @Published var username: String
}


class GlobalVC: ObservableObject{
    init(){
        selectedLesson = nil
        selectedExam = nil
        showLessonEditView = false
        showExamEditView = false
    }
    
    @Published var selectedLesson: Lesson?
    @Published var selectedExam: Exam?
    
    @Published var showLessonEditView: Bool
    @Published var showExamEditView: Bool
    
    func setSelectedLesson(with: Lesson?, addMode: Bool = false){
        selectedLesson = with
        if with != nil || addMode{
            showLessonEditView = true
        } else {
            showLessonEditView = false
        }
        showExamEditView = false
        selectedExam = nil
    }
    
    func setSelectedExam(with: Exam?, addMode: Bool = false){
        selectedExam = with
        if with != nil || addMode{
            showExamEditView = true
        } else {
            showExamEditView = false
        }
        showLessonEditView = false
        selectedLesson = nil
    }
}
