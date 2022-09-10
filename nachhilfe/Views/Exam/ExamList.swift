//
//  ExamList.swift
//  nachhilfe
//
//  Created by anh :) on 10.09.22.
//

import SwiftUI
import RealmSwift

struct ExamList: View {
    @Binding var selectedExam: Exam?
    @Binding var showExamEditView: Bool
    @Binding var editViewType: EditViewTypes
    
    @ObservedResults(Exam.self, sortDescriptor: SortDescriptor(keyPath: "date", ascending: false)) var exams
    
    @State var selectedStudent: Student? = nil
    
    @State var showAllExams: Bool = false
    
    var body: some View{
        VStack {
            HStack(spacing: 12.5) {
                if selectedStudent == nil{
                    Text("Alle").font(.title3.weight(.bold))
                } else {
                    Text(selectedStudent!.surname + " " + selectedStudent!.name)
                        .font(.title3.weight(.bold))
                }
                Spacer()
                Button(action: {
                    withAnimation{
                        showAllExams.toggle()
                    }
                }, label: {
                    Text(showAllExams ? "Erledigte Klausuren ausblenden" : "Alle Klausuren einblenden")
                        .font(.body.weight(.regular))
                        .foregroundColor(.teal)
                })
                StudentPickerSmall(selectedStudent: $selectedStudent)
            }.padding([.leading, .trailing])
                .padding(.bottom, -5)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 10) {
                    if selectedStudent == nil {
                        ForEach(exams, id: \.self){ exam in
                            Text("\(exam.date)")
                                .onTapGesture {
                                    withAnimation{
                                        selectedExam = exam
                                        editViewType = .edit
                                        showExamEditView = true
                                    }
                                }
                        }
                    } else {
                        ForEach(selectedStudent!.exams, id: \.self){ exam in
                            Text("\(exam.date)")
                                .onTapGesture {
                                    withAnimation{
                                        selectedExam = exam
                                        editViewType = .edit
                                        showExamEditView = true
                                    }
                                }
                        }
                    }
                }.padding([.leading, .trailing])
                    .padding([.top, .bottom], 3)
            }
            Spacer()
        }
    }
}
