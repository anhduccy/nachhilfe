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

struct HomeView: View, KeyboardReadable {
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
        .padding(.leading, 50)
        .padding(.trailing, 50)
        .ignoresSafeArea(.keyboard)
    }
}
