//
//  StudentView.swift
//  nachhilfe
//
//  Created by anh :) on 29.10.22.
//

import SwiftUI
import RealmSwift
import Realm

struct LessonCard: View{
    @Environment(\.colorScheme) var appearance
    let title: String
    @ObservedRealmObject var lesson: Lesson
    @Binding var selectedLesson: Lesson?
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
            if selectedLesson?._id == lesson._id && showLessonEditView{
                RoundedRectangle(cornerRadius: 10).foregroundColor(lesson.student.first!.color.color)
                    .opacity(0.1)
                    .shadow(radius: 1.5)
            } else {
                RoundedRectangle(cornerRadius: 10).fill(appearance == .dark ? Color.init(red: 30/255, green: 30/255, blue: 30/255) : Color.white)
                    .shadow(radius: 1.5)
            }
            
            VStack(alignment: .leading, spacing: 10){
                VStack(alignment: .leading, spacing: 0){
                    HStack(spacing: 3){
                        Text(title)
                            .font(.title3.weight(.bold))
                            .foregroundColor(lesson.student.first!.color.color)
                            
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
                    Text(dateFormatter.string(from: lesson.date))
                        .font(.callout.bold())
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
            }.padding()
            .foregroundColor(appearance == .dark ? .white : .black)
        }.frame(width: width, height: height)
    }
}

struct StudentView: View{
    @ObservedRealmObject var student: Student

    @State var selectedLesson: Lesson? = nil
    @State var showLessonEditView: Bool = false
    @State var editViewType: EditViewTypes = .add
    
    @State var showAllLessons: Bool = false
        
    var body: some View{
        HStack{
            GeometryReader{ geo in
                VStack(spacing: 15){
                    ViewHeader("\(student.surname) \(student.name)", color: student.color.color){
                        selectedLesson = nil
                        editViewType = .add
                        showLessonEditView = true
                    }
                    HStack{
                        VStack{
                            if !student.lessons.filter("date<%@", Date() as CVarArg).isEmpty{
                                LessonCard(title: "Letzte Nachhilfestunde", lesson: student.lessons.sorted(byKeyPath: "date", ascending: false).filter("date<%@", Date() as CVarArg).first!, selectedLesson: $selectedLesson, showLessonEditView: $showLessonEditView, width: geo.size.width/2, height: 125)
                                    .onTapGesture {
                                        withAnimation{
                                            selectedLesson = student.lessons.sorted(byKeyPath: "date", ascending: false).filter("date<%@", Date() as CVarArg).first!
                                            
                                            editViewType = .edit
                                            showLessonEditView = true
                                        }
                                    }
                            }
                            if !student.lessons.filter("date>%@", Date() as CVarArg).isEmpty{
                                LessonCard(title: "Nächste Nachhilfestunde", lesson: student.lessons.filter("date>%@", Date() as CVarArg).first!, selectedLesson: $selectedLesson, showLessonEditView: $showLessonEditView, width: geo.size.width/2, height: 125)
                                    .onTapGesture {
                                        withAnimation{
                                            selectedLesson = student.lessons.sorted(byKeyPath: "date", ascending: false).filter("date>%@", Date() as CVarArg).first!
                                            
                                            editViewType = .edit
                                            showLessonEditView = true
                                        }
                                    }
                            }
                            Spacer()
                        }.frame(width: geo.size.width/2)
                        
                        VStack{
                            HStack{
                                Text("Nachhilfestunden").font(.title3.weight(.bold))
                                Spacer()
                                Button(showAllLessons ? "Erledigte ausblenden" : "Alle anzeigen"){
                                    withAnimation{
                                        showAllLessons.toggle()
                                    }
                                }.foregroundColor(student.color.color)
                            }
                            
                            ScrollView(.vertical, showsIndicators: false){
                                VStack{
                                    if student.lessons.isEmpty{
                                        LeftText("Keine Nachhilfestunden eingetragen")
                                            .foregroundColor(.gray)
                                    } else if student.lessons.filter("isPayed == false || isDone == false").isEmpty && !showAllLessons{
                                        LeftText("Alle Nachhilfestunden erledigt")
                                            .foregroundColor(.gray)
                                    } else {
                                        ForEach(lessons(), id: \.self){ lesson in
                                            LessonListItem(selectedLesson: $selectedLesson, lesson: lesson, showLessonEditView: $showLessonEditView, all: false)
                                                .onTapGesture {
                                                    withAnimation{
                                                        selectedLesson = lesson
                                                        editViewType = .edit
                                                        showLessonEditView = true
                                                    }
                                                }
                                        }.padding([.trailing, .leading], 5)
                                            .padding([.top, .bottom], 2)
                                    }
                                }
                            }
                        }
                        .padding([.leading, .trailing])
                        .frame(width: geo.size.width/2)
                    }
                }
            }.padding()
            
            if showLessonEditView {
                Divider()
                LessonEditView(type: editViewType, lesson: selectedLesson, isPresented: $showLessonEditView)
                    .frame(width: 350)
            }
        }
    }
    private func lessons()->Results<Lesson>{
        let studentLessons = student.lessons.sorted(byKeyPath: "date", ascending: false)
        if showAllLessons {
            return studentLessons.filter(NSPredicate(value: true))
        } else {
            return studentLessons.filter("isPayed == false || isDone == false")
        }
    }
}

