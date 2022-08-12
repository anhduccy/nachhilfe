//
//  HomeView.swift
//  nachhilfe
//
//  Created by anh :) on 09.08.22.
//

import SwiftUI
import Realm
import RealmSwift

struct HomeView: View {
    @ObservedResults(Student.self) var students
    
    @State var showStudentView: Bool = false
    @State var editViewType: EditViewTypes = .add
    
    var body: some View {
        ZStack{
            HStack{
                VStack(spacing: 30){
                    LeftText("Hallo Anh!", font: .system(size: 50), fontWeight: .black)
                    VStack{
                        HStack{
                            LeftText("Alle Nachhilfeschüler", font: .title, fontWeight: .bold)
                            Spacer()
                            Button(action: {
                                showStudentView = true
                                editViewType = .add
                            }, label: {
                                Icon(systemName: "plus")
                            })
                        }
                        ScrollView(.horizontal, showsIndicators: false){
                            HStack(spacing: 10){
                                ForEach(students, id: \.self){ student in
                                    StudentCard(student: student, editViewType: $editViewType)
                                }
                            }
                        }
                    }
                    Spacer()
                }
                
                StudentEditView(type: .add, student: nil, isPresented: $showStudentView)
            }
        }
        .padding(50)
    }
}

struct StudentCard: View{
    let student: Student
    @State var showStudentEditView: Bool = false
    @Binding var editViewType: EditViewTypes
    
    var body: some View{
        ZStack{
            //Background
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(.teal)
            VStack{
                HStack(alignment: .top){
                    Image(systemName: "person.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 30)
                        .opacity(0.5)
                    Spacer()
                    Button(action: {
                        showStudentEditView.toggle()
                    }, label: {
                        Image(systemName: "info.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 15)
                    }).sheet(isPresented: $showStudentEditView){
                        StudentEditView(type: .edit, student: student, isPresented: $showStudentEditView)
                    }
                }.foregroundColor(.white)
                Spacer()
            }.padding(15)
            
            //Foreground
            VStack{
                Spacer()
                Text(student.surname + " " + student.name)
                    .font(.title.weight(.bold))
                Spacer()
            }
            .foregroundColor(.white)
            .padding(30)
        }.frame(width: 275, height: 200)
    }
}
