//
//  LessonListItem.swift
//  nachhilfe
//
//  Created by anh :) on 10.09.22.
//

import SwiftUI
import RealmSwift

struct LessonListItem: View{
    @EnvironmentObject var globalVC: GlobalVC
    @Environment(\.colorScheme) var appearance
    @ObservedRealmObject var lesson: Lesson
    let dateMode: Bool
    
    @State var showAlert: Bool = false
    
    var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YYYY"
        dateFormatter.locale = Locale(identifier: "de_DE")
        return dateFormatter
    }

    var body: some View{
        ZStack {
            if globalVC.selectedLesson?._id == lesson._id && globalVC.showLessonEditView{
                RoundedRectangle(cornerRadius: 10).foregroundColor(lesson.student.first?.color.color ?? .teal)
                    .opacity(0.1)
                    .shadow(radius: 1.5)
            } else {
                RoundedRectangle(cornerRadius: 10).fill(appearance == .dark ? Color.init(red: 30/255, green: 30/255, blue: 30/255) : Color.white)
                    .shadow(radius: 1.5)
            }
            
            HStack(spacing: 15) {
                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 10){
                        if dateMode{
                            Text(dateFormatter.string(from: lesson.date))
                        } else {
                            Image(systemName: "clock")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 15)
                                .foregroundColor(lesson.student.first?.color.color ?? .teal)
                                .fontWeight(.regular)
                            Text((lesson.student.first?.surname ?? "Stunde") + " " + (lesson.student.first?.name ?? "gelöscht"))
                                .foregroundColor(lesson.student.first?.color.color ?? .teal)
                        }
                        if !lesson.notes.isEmpty{
                            Image(systemName: "text.alignleft")
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                    }.font(.callout.bold())
                    if !lesson.content.isEmpty{
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
