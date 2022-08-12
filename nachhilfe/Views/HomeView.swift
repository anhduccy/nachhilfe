//
//  HomeView.swift
//  nachhilfe
//
//  Created by anh :) on 09.08.22.
//

import SwiftUI
import Realm
import RealmSwift
import UIKit

struct HomeView: View {
    @ObservedResults(Student.self) var students
    
    @State var showStudentEditView: Bool = false
    @State var editViewType: EditViewTypes = .add
    @State var selectedStudent: Student? = nil
    
    @State var username: String = "Anh"
    
    var body: some View {
        ZStack{
            VStack(spacing: 30){
                HStack(spacing: 7){
                    Text("Hallo")
                        .font(.system(size: 50).weight(.black))
                    Text(username+"!")
                        .font(.system(size: 50).weight(.black))
                        .foregroundColor(.teal)
                    Spacer()
                }
                VStack{
                    HStack{
                        LeftText("Alle Nachhilfeschüler", font: .title, fontWeight: .bold)
                        Spacer()
                        Button(action: {
                            withAnimation{
                                editViewType = .add
                                selectedStudent = nil
                                showStudentEditView = true
                            }
                        }, label: {
                            Icon(systemName: "plus")
                        })
                    }
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(spacing: 10){
                            ForEach(students, id: \.self){ student in
                                StudentCard(student: student, selectedStudent: $selectedStudent, showStudentEditView: $showStudentEditView, editViewType: $editViewType)
                            }
                        }
                    }
                }
                Spacer()
            }
                
            StudentEditView(type: editViewType, student: selectedStudent, isPresented: $showStudentEditView)
                .offset(x: showStudentEditView ? 330 : UIScreen().bounds.width+750, y: UIScreen().bounds.height-350/2)
                        
        }
        .padding(50)
    }
}

struct StudentCard: View{
    let student: Student
    @Binding var selectedStudent: Student?
    @Binding var showStudentEditView: Bool
    @Binding var editViewType: EditViewTypes
    
    var body: some View{
        ZStack{
            GlassBackground(width: 275, height: 200, color: student.color.color)
            VStack{
                HStack(alignment: .top){
                    Image(systemName: "person.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 30)
                        .opacity(0.5)
                    Spacer()
                    Button(action: {
                        withAnimation{
                            editViewType = .edit
                            selectedStudent = student
                            showStudentEditView = true
                        }
                    }, label: {
                        Image(systemName: "info.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 15)
                    })
                }.foregroundColor(student.color.color)
                Spacer()
            }.padding(15)
            
            //Foreground
            VStack{
                Spacer()
                Text(student.surname + " " + student.name)
                    .font(.title.weight(.bold))
                Spacer()
            }
            .foregroundColor(student.color.color)
            .padding(30)
        }.frame(width: 275, height: 200)
    }
}
