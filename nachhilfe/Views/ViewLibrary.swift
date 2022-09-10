//
//  ViewLibrary.swift
//  nachhilfe
//
//  Created by anh :) on 09.08.22.
//

import SwiftUI
import UIKit
import Combine
import RealmSwift


/// Publisher to read keyboard changes.
protocol KeyboardReadable {
    var keyboardPublisher: AnyPublisher<Bool, Never> { get }
}

extension KeyboardReadable {
    var keyboardPublisher: AnyPublisher<Bool, Never> {
        Publishers.Merge(
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillShowNotification)
                .map { _ in true },
            
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillHideNotification)
                .map { _ in false }
        )
        .eraseToAnyPublisher()
    }
}


struct LeftText: View{
    init(_ text: String, font: Font = .body, fontWeight: Font.Weight = .regular){
        self.text = text
        self.font = font
        self.fontWeight = fontWeight
    }
    let text: String
    let font: Font
    let fontWeight: Font.Weight

    var body: some View{
        HStack{
            Text(text)
                .font(font)
                .fontWeight(fontWeight)
            Spacer()
        }
    }
}

struct Icon: View{
    init(systemName: String, color: Color = .teal, size: CGFloat = 30, isActivated: Bool = true){
        self.systemName = systemName
        self.color = color
        self.size = size
        self.isActivated = isActivated
    }
    private let systemName: String
    private let color: Color
    private let size: CGFloat
    private let isActivated: Bool
    
    var body: some View{
        ZStack{
            Circle()
                .fill(isActivated ? color : .gray)
                .opacity(0.2)
                .frame(width: size, height: size)
            Image(systemName: systemName)
                .resizable()
                .scaledToFit()
                .frame(width: size/2)
                .foregroundColor(isActivated ? color : .gray)
        }
    }
}

struct GlassBackground: View {
    let width: CGFloat
    let height: CGFloat
    let color: Color

    var body: some View {
        ZStack{
            RadialGradient(colors: [.clear, color],
                           center: .center,
                           startRadius: 1,
                           endRadius: 100)
                .opacity(0.6)
            Rectangle().foregroundColor(color)
        }
        .opacity(0.2)
        .blur(radius: 2)
        .cornerRadius(15)
        .frame(width: width, height: height)
    }
}

//Navigation header for LessonView and ExamView
struct ViewHeader: View{
    init(_ section: String, action: @escaping ()->()){
        self.section = section
        self.action = action
    }
    let section: String
    let action: () -> ()
    var body: some View{
        VStack(spacing: 0){
            HStack(alignment: .bottom, spacing: 10){
                Text("Übersicht").font(.system(size: 50).weight(.heavy))
                Spacer()
                Button(action: {
                    withAnimation{
                        action()
                    }
                }, label: {
                    Icon(systemName: "plus")
                })
            }
            LeftText(section, font: .title2, fontWeight: .bold)
                .foregroundColor(.teal)
        }
    }
}

//Student-Picker for LessonList and ExamList
struct StudentPickerSmall: View{
    @ObservedResults(Student.self) var students
    @Binding var selectedStudent: Student?
    
    var body: some View{
        Menu(content: {
            Button(action: {
                selectedStudent = nil
            }, label: {
                HStack{
                    Text("Alle")
                    if selectedStudent == nil{
                        Image(systemName: "checkmark")
                    }
                }
            })
            
            ForEach(students, id: \.self){ student in
                Button(action: {
                    selectedStudent = student
                }, label: {
                    HStack{
                        Text(student.surname + " " + student.name)
                        if selectedStudent == student{
                            Image(systemName: "checkmark")
                        }
                    }
                })
            }
        }, label: {
            Text("Schüler/in wählen").font(.body.weight(.regular))
                .foregroundColor(.teal)
        })
    }
}

struct StudentPickerLarge: View{
    init(_ type: String, model: LessonModel){
        self.type = type
        self.model = model
    }
    
    @ObservedResults(Student.self) var students
    @ObservedObject var model: LessonModel
    
    var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd. MMMM. YYYY"
        dateFormatter.locale = Locale(identifier: "de_DE")
        return dateFormatter
    }
    let type: String
    
    var body: some View{
        Menu(content: {
            ForEach(students, id:\.self){ student in
                Button(action: {
                    model.student = student
                }, label: {
                    HStack{
                        Text(student.surname + " " + student.name)
                        if model.student._id == student._id {
                            Image(systemName: "checkmark")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 15)
                        }
                    }
                })
            }
        }, label: {
            VStack(spacing: 0){
                if model.student.surname == "" && model.student.name == ""{
                    LeftText("\(type) hinzufügen", font: .title, fontWeight: .bold)
                        .foregroundColor(model.student.color.color)
                    LeftText("Tippe um Auszuwählen", font: .callout)
                        .foregroundColor(.gray)
                } else {
                    LeftText("\(model.student.surname) \(model.student.name)", font: .title, fontWeight: .bold)
                        .foregroundColor(model.student.color.color)
                    LeftText("\(type) vom \(dateFormatter.string(from: model.date))", font: .callout)
                        .foregroundColor(.gray)
                }
            }
        })
    }
}
