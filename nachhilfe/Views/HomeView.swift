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
    var body: some View {
        ZStack{
            VStack(spacing: 30){
                LeftText("Hallo Anh!", font: .system(size: 50), fontWeight: .black)
                VStack{
                    HStack{
                        LeftText("Alle Nachhilfeschüler", font: .title, fontWeight: .black)
                        Spacer()
                        Button(action: {
                            showStudentView = true
                        }, label: {
                            Icon(systemName: "plus")
                        })
                        .popover(isPresented: $showStudentView){
                            StudentView(isPresented: $showStudentView)
                        }
                    }
                    HStack{
                        ScrollView(.horizontal, showsIndicators: false){
                            ForEach(students, id: \.self){ student in
                                Text(student.surname)
                            }
                        }
                    }
                }
                Spacer()
            }
        }
        .padding(50)
    }
}
