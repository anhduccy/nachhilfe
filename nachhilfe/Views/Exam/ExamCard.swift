//
//  ExamCard.swift
//  nachhilfe
//
//  Created by anh :) on 24.12.22.
//

import SwiftUI
import RealmSwift

struct ExamCard: View{
    @EnvironmentObject var globalVC: GlobalVC
    @Environment(\.colorScheme) var appearance
    let title: String
    @ObservedRealmObject var exam: Exam
    @Binding var showExamEditView: Bool
    let width: CGFloat
    let height: CGFloat
    
    let foregroundColor: Color
    let backgroundColor: Color
    let backgroundColorDark: Color
    let selectedColor: Color
    
    init(title: String, exam: Exam, showExamEditView: Binding<Bool>, width: CGFloat, height: CGFloat, color: Color){
        self.title = title
        self.exam = exam
        _showExamEditView = showExamEditView
        self.width = width
        self.height = height
        
        if color == .white{
            foregroundColor = exam.student.first!.color.color
            backgroundColor = color
            backgroundColorDark = Color.init(red: 30/255, green: 30/255, blue: 30/255)
            selectedColor = exam.student.first!.color.color
        } else {
            foregroundColor = .white
            backgroundColor = color
            backgroundColorDark = color
            selectedColor = exam.student.first!.color.color
        }
    }
    
    var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YYYY"
        dateFormatter.locale = Locale(identifier: "de_DE")
        return dateFormatter
    }
        
    var body: some View{
        ZStack(alignment: .center){
            if globalVC.selectedExam?._id == exam._id && showExamEditView{
                RoundedRectangle(cornerRadius: 10).foregroundColor(selectedColor)
                    .opacity(0.15)
                    .shadow(radius: 1.5)
            } else {
                RoundedRectangle(cornerRadius: 10).fill(appearance == .dark ? backgroundColorDark : backgroundColor)
                    .opacity(appearance == .dark ? 1 : 0.9)
                    .shadow(radius: 1.5)
            }
            HStack{
                VStack(alignment: .leading, spacing: 0){
                    HStack(spacing: 5){
                        Text(title)
                            .font(.body.weight(.bold))
                        if !exam.topics.isEmpty{
                            Image(systemName: "text.alignleft")
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Text(dateFormatter.string(from: exam.date)).font(.callout.bold())
                        .foregroundColor(appearance == .dark ? .white : (backgroundColor == .white) ? .black : (globalVC.selectedExam?._id == exam._id && showExamEditView) ? .black : .white)
                }
                Spacer()
                if exam.grade == -1{
                    Text("--").font(.title2.weight(.heavy))
                } else {
                    Text("\(exam.grade)").font(.title.weight(.heavy))
                }
            }.padding([.leading, .trailing])
                .foregroundColor((globalVC.selectedExam?._id == exam._id && showExamEditView) ? exam.student.first!.color.color : foregroundColor)
        }.frame(width: width, height: height)
    }
}
