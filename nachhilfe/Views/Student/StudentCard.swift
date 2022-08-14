//
//  StudentCard.swift
//  nachhilfe
//
//  Created by anh :) on 14.08.22.
//

import SwiftUI

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