//
//  LessonListItem.swift
//  nachhilfe
//
//  Created by anh :) on 10.09.22.
//

import SwiftUI
import RealmSwift

struct LessonListItem: View{
    @Environment(\.colorScheme) var appearance
    @Binding var selectedLesson: Lesson?
    @ObservedRealmObject var lesson: Lesson
    @Binding var showLessonEditView: Bool
    let all: Bool
    
    var dateFormatter: DateFormatter {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.YYYY"
            dateFormatter.locale = Locale(identifier: "de_DE")
            return dateFormatter
        }

    var body: some View{
        ZStack {
            if selectedLesson?._id == lesson._id && showLessonEditView{
                RoundedRectangle(cornerRadius: 10).foregroundColor(lesson.student.first!.color.color)
                    .opacity(0.1)
                    .cornerRadius(10)
                    .shadow(color: .teal, radius: 1.5)
            } else {
                RoundedRectangle(cornerRadius: 10).fill(appearance == .dark ? Color.init(red: 30/255, green: 30/255, blue: 30/255) : Color.white)
                    .shadow(radius: 1.5)
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 5){
                        Text(dateFormatter.string(from: lesson.date))
                            .font(.callout.bold())
                        if all{
                            Text((lesson.student.first?.surname ?? "Stunde") + " " + (lesson.student.first?.name ?? "gelöscht"))
                                .font(.callout.bold())
                                .foregroundColor(lesson.student.first?.color.color ?? .teal)
                        }
                    }
                    VStack(alignment: .leading){
                        if lesson.isPayed && lesson.isDone{
                            Text("Stunde erledigt und bezahlt")
                                .foregroundColor(.gray)
                        }
                        if lesson.isPayed && !lesson.isDone{
                            Text("Vorzahlung, Stunde nicht erledigt")
                                .foregroundColor(.red)
                        }
                        if !lesson.isPayed && lesson.isDone{
                            Text("Stunde erledigt, Zahlung ausstehend")
                                .foregroundColor(.red)
                        }
                        if !lesson.isPayed && !lesson.isDone{
                            Text("Stunde nicht erledigt, Zahlung ausstehend")
                                .foregroundColor(.gray)
                        }
                        
                    }.font(.footnote)
                    if lesson.content != ""{
                        LeftText(lesson.content, font: .footnote).foregroundColor(.gray)
                            .padding(.top, 5)
                            .lineLimit(2)
                    }
                }
                Spacer()
                if lesson.notes != ""{
                    Image(systemName: "note.text")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 17.5)
                        .foregroundColor(.gray)
                }
                HStack(spacing: 5){
                    Image(systemName: lesson.isDone ? "checkmark.circle.fill" : "checkmark.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25)
                        .onTapGesture {
                            withAnimation{
                                try! realmEnv.write{
                                    $lesson.isDone.wrappedValue.toggle()
                                }
                            }
                        }
                        .foregroundColor(lesson.isDone ? lesson.student.first!.color.color : .gray)
                        .opacity(lesson.isDone ? 1 : 0.5)
                    
                    Image(systemName: lesson.isPayed ? "eurosign.circle.fill" : "eurosign.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25)
                        .onTapGesture {
                            withAnimation{
                                try! realmEnv.write{
                                    $lesson.isPayed.wrappedValue.toggle()
                                }
                            }
                        }
                        .foregroundColor(lesson.isPayed ? .green : .gray)
                        .opacity(lesson.isPayed ? 1 : 0.5)
                }
            }.padding()
        }
        .fixedSize(horizontal: false, vertical: true)
    }
}
