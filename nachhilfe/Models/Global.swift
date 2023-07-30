//
//  Global.swift
//  nachhilfe
//
//  Created by anh :) on 09.08.22.
//

import Foundation

class Global: ObservableObject{
    init(){
        username = ""
    }
    @Published var username: String
}

public func toggleSidebar() { // 2
    #if os(iOS)
    #else
    NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
    #endif
}

class GlobalVC: ObservableObject{
    init(){
        selectedLesson = nil
        selectedExam = nil
    }
    
    @Published var selectedLesson: Lesson?
    @Published var selectedExam: Exam?
    
    func setSelectedLesson(with: Lesson?){
        selectedLesson = with
    }
    
    func setSelectedExam(with: Exam?){
        selectedExam = with
    }
}
