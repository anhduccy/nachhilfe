//
//  LessonCard.swift
//  nachhilfe
//
//  Created by anh :) on 24.12.22.
//

import SwiftUI
import RealmSwift

struct LessonCard: View{
    @EnvironmentObject var globalVC: GlobalVC
    @Environment(\.colorScheme) var appearance
    let title: String
    @ObservedRealmObject var lesson: Lesson
    @Binding var showLessonEditView: Bool
    let width: CGFloat
    let height: CGFloat
    
    var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YYYY"
        dateFormatter.locale = Locale(identifier: "de_DE")
        return dateFormatter
    }
        
    var body: some View{
        ZStack(alignment: .top){
            if globalVC.selectedLesson?._id == lesson._id && showLessonEditView{
                RoundedRectangle(cornerRadius: 10).foregroundColor(lesson.student.first!.color.color)
                    .opacity(0.15)
                    .shadow(radius: 1.5)
            } else {
                RoundedRectangle(cornerRadius: 10).fill(appearance == .dark ? Color.init(red: 30/255, green: 30/255, blue: 30/255) : Color.white)
                    .shadow(radius: 1.5)
            }
            VStack(alignment: .leading, spacing: 10){
                HStack(alignment: .top, spacing: 3){
                    VStack(alignment: .leading, spacing: 0){
                        HStack(spacing: 5){
                            Text(title)
                                .font(.body.weight(.bold))
                                .foregroundColor(lesson.student.first!.color.color)
                            if !lesson.notes.isEmpty{
                                Image(systemName: "text.alignleft")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }
                        }
                        Text(dateFormatter.string(from: lesson.date))
                            .font(.callout.bold())
                    }
                    Spacer()
                    InteractiveIcon(image: lesson.isDone ? "checkmark.circle.fill" : "checkmark.circle", bool: $lesson.isDone, color: lesson.student.first!.color.color)
                        .onTapGesture {
                            withAnimation{
                                try! realmEnv.write{
                                    $lesson.isDone.wrappedValue.toggle()
                                }
                            }
                        }
                    InteractiveIcon(image: lesson.isPayed ? "eurosign.circle.fill" : "eurosign.circle", bool: $lesson.isPayed, color: .green)
                        .onTapGesture {
                            withAnimation{
                                $lesson.isPayed.wrappedValue.toggle()
                            }
                        }
                }
                if lesson.content.isEmpty{
                    Text("Noch kein Inhalt vorhanden")
                        .font(.footnote)
                        .foregroundColor(.gray)
                } else {
                    Text(lesson.content)
                        .font(.footnote)
                       .lineLimit(2)
                       .foregroundColor(.gray)
                }
            }
            .padding()
            .foregroundColor(appearance == .dark ? .white : .black)
        }.frame(width: width, height: height)
    }
}
