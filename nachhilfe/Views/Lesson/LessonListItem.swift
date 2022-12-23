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
    
    @State var showAlert: Bool = false
    
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
                    .shadow(radius: 1.5)
            } else {
                RoundedRectangle(cornerRadius: 10).fill(appearance == .dark ? Color.init(red: 30/255, green: 30/255, blue: 30/255) : Color.white)
                    .shadow(radius: 1.5)
            }
            
            HStack(spacing: 15) {
                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 5){
                        Text(dateFormatter.string(from: lesson.date))
                            .font(.callout.bold())
                        if all{
                            Text((lesson.student.first?.surname ?? "Stunde") + " " + (lesson.student.first?.name ?? "gelöscht"))
                                .font(.callout.bold())
                                .foregroundColor(lesson.student.first?.color.color ?? .teal)
                        }
                        if lesson.notes != ""{
                            Image(systemName: "note.text")
                                .font(.callout)
                                .foregroundColor(.gray)
                        }
                    }
                    if lesson.content != ""{
                        LeftText(lesson.content, font: .footnote).foregroundColor(.gray)
                            .padding(.top, 5)
                            .lineLimit(2)
                    }
                }
                Spacer()
                
                HStack(spacing: 10){
                    if lesson.isDone && !lesson.isPayed || !lesson.isDone && lesson.isPayed{
                        Icon(systemName: "info.circle", color: .red, size: 20)
                            .onTapGesture{
                                showAlert.toggle()
                            }
                            .popover(isPresented: $showAlert){
                                VStack{
                                    if lesson.isPayed && !lesson.isDone{
                                        Text("Vorzahlung, Stunde nicht erledigt")
                                    }
                                    if !lesson.isPayed && lesson.isDone{
                                        Text("Stunde erledigt, Zahlung ausstehend")
                                    }
                                }.font(.footnote)
                                    .foregroundColor(.red)
                                    .padding()
                            }
                        
                    }
                    
                    HStack(spacing: 5){
                        InteractiveIcon(image: lesson.isDone ? "checkmark.circle.fill" : "checkmark.circle", bool: $lesson.isDone, color: lesson.student.first?.color.color ?? .teal)
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
                }
            }.padding()
        }
        .fixedSize(horizontal: false, vertical: true)
    }
}
