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

struct InteractiveIcon: View{
    let image: String
    @Binding var bool: Bool
    let color: Color
    var body: some View{
        Image(systemName: image)
            .resizable()
            .scaledToFit()
            .frame(width: 25)
            .foregroundColor(bool ? color : .gray)
            .opacity(bool ? 1 : 0.5)
    }
}

struct GlassBackground: View {
    let width: CGFloat
    let height: CGFloat
    let color: Color

    var body: some View {
        ZStack{
            Rectangle().foregroundColor(color)
        }
        .opacity(0.2)
        .cornerRadius(15)
        .frame(width: width, height: height)
    }
}

//Navigation header for LessonView and ExamView
struct ViewHeader: View{
    init(_ section: String, color: Color = .teal, action: @escaping ()->()){
        self.section = section
        self.action = action
        self.color = color
    }
    let section: String
    let action: () -> ()
    let color: Color
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
                    Icon(systemName: "plus", color: color)
                })
            }
            LeftText(section, font: .title2, fontWeight: .bold)
                .foregroundColor(color)
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
