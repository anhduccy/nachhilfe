//
//  LessonEditView.swift
//  nachhilfe
//
//  Created by anh :) on 14.08.22.
//

import SwiftUI
import Realm
import RealmSwift

struct LessonEditView: View {
    init(type: EditViewTypes, lesson: Lesson?, isPresented: Binding<Bool>){
        _isPresented = isPresented
        self.type = type
        if type == .add{
            self.model = LessonModel()
            self.selectedLesson = Lesson()
        } else {
            self.model = LessonModel().toLayer(lesson: lesson!)
            self.selectedLesson = lesson!
        }
        
        let students = realmEnv.objects(Student.self)
        if students.first != nil {
            _selectedStudent = State(initialValue: students.first!)
        } else {
            _selectedStudent = State(initialValue: Student()) //TO-DO: ERROR MELDUNG
        }
    }
    
    @Environment(\.colorScheme) var appearance
    @Binding var isPresented: Bool
    let type: EditViewTypes
    @ObservedRealmObject var selectedLesson: Lesson
    @ObservedObject var model: LessonModel
    
    @ObservedResults(Student.self) var students
    @State var selectedStudent: Student
    
    var body: some View {
        GeometryReader{ geo in
            ZStack{
                VStack{
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .leading){
                            LeftText(type == .add ? "Stunde hinzufügen" : "Stunde vom /{Datum}", font: .title, fontWeight: .bold)
                                .foregroundColor(.teal)
                            Picker("", selection: $selectedStudent){
                                ForEach(students, id:\.self){ student in
                                    Text(student.surname + " " + student.name).tag(student)
                                }
                            }
                            HStack{
                                Text("Dauer")
                                TextField("in Minuten", value: $model.duration, format: .number)
                                    .keyboardType(.decimalPad)
                                    .textFieldStyle(.plain)
                                Spacer()
                            }
                            
                            
                            DatePicker("", selection: $model.date, displayedComponents: [.date, .hourAndMinute])
                                .datePickerStyle(.graphical)
                            
                            VStack(spacing: 0) {
                                LeftText("Inhalt der Nachhilfestunde", font: .title2, fontWeight: .bold)
                                TextEditor(text: $model.content)
                                    .border(.teal)
                            }
                            
                            VStack(spacing: 0) {
                                LeftText("Notizen", font: .title2, fontWeight: .bold)
                                TextEditor(text: $model.notes)
                                    .border(.teal)

                            }
                        
                            Spacer()
                        }
                    }
                    HStack{
                        Spacer()
                        Button("Fertig"){
                            if type == .add{
                                Lesson.add(student: selectedStudent, model: model)
                            } else if type == .edit{
                                Lesson.update(lesson: $selectedLesson, model: model)
                            }
                            isPresented = false
                        }.bold()
                            .foregroundColor(.teal)
                    }
                }
                .padding()
                .background(appearance == .dark ? .black : .white)
                .cornerRadius(20)
                .frame(height: geo.size.height*0.9)
                .shadow(color: appearance == .dark ? .teal : .gray, radius: 2.5)
            }
        }.frame(width: 350)
    }
}

