//
//  SalesView.swift
//  nachhilfe
//
//  Created by anh :) on 25.12.22.
//

import SwiftUI
import Charts
import RealmSwift

class MonthNavigator{
    static func getCurrentMonth(date: Date = Date())->Int{
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month], from: date)
        return components.month!
    }
    
    static func getDateFromComponents(year: Int? = Calendar.current.dateComponents([.year], from: Date()).year, month: Int?, day: Int? = 1)->Date{
        let calendar = Calendar.current
        let dateComponents = DateComponents(year: year, month: month, day: day)
        return calendar.date(from: dateComponents) ?? Date()
    }

    static func getYear(input: Int?)->String{
        let date = getDateFromComponents(month: input!+1)
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY"
        return formatter.string(from: date)
    }
    
    static func getMonth(input: Int?)->String{
        let date = getDateFromComponents(month: input)
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        formatter.locale = Locale(identifier: "de")
        return formatter.string(from: date)
    }
}

struct SalesView: View {
    @ObservedResults(Student.self) var students
    @State var showAllSales: Bool = false
    @State var selectedMonth: Int = MonthNavigator.getCurrentMonth()
    
    var navigationBar: (some View){
        return
            HStack(spacing: 10){
                if showAllSales{
                    Text("Gesamtumsatz").font(.title2.bold())
                } else {
                    HStack(spacing: 3){
                        Button(action: {
                            selectedMonth -= 1
                        }, label: {
                            Icon2(systemName: "chevron.backward", size: 27.5)
                        })
                        
                        Button(action: {
                            selectedMonth += 1
                        }, label: {
                            Icon2(systemName: "chevron.forward", size: 27.5)
                        })
                    }
                    Button(action: {selectedMonth = MonthNavigator.getCurrentMonth()}, label: {Icon(systemName: "calendar")})
                    Text(MonthNavigator.getMonth(input: selectedMonth) + " " + MonthNavigator.getYear(input: selectedMonth)).font(.title2.bold())
                }
                Spacer()
                Button(showAllSales ? "Monatlich anzeigen" : "Gesamthistorie anzeigen"){
                    withAnimation{
                        showAllSales.toggle()
                    }
                }.foregroundColor(.teal)
            }
    }
    
    var body: some View {
        GeometryReader{ geo in
            VStack(spacing: 20){
                ViewHeader("Umsatzhistorie", hasButton: false, action: {})
                
                if showAllSales{
                    navigationBar.frame(width: geo.size.width/2)
                } else {
                    navigationBar
                }
                
                HStack{
                    if !showAllSales{
                        ZStack{
                            Chart{
                                let data: [SalesPosition] = [
                                    .init(name: "\(MonthNavigator.getMonth(input: selectedMonth-3)  + " " + MonthNavigator.getYear(input: selectedMonth-3))", betrag: salesPayed(selectedMonth-3), color: "Gezahlt"),
                                    .init(name: "\(MonthNavigator.getMonth(input: selectedMonth-3)  + " " + MonthNavigator.getYear(input: selectedMonth-3))", betrag: salesTotal(selectedMonth-3)-salesPayed(selectedMonth-3), color: "Noch nicht gezahlt"),
                                    
                                    .init(name: "\(MonthNavigator.getMonth(input: selectedMonth-2)  + " " + MonthNavigator.getYear(input: selectedMonth-2))", betrag: salesPayed(selectedMonth-2), color: "Gezahlt"),
                                    .init(name: "\(MonthNavigator.getMonth(input: selectedMonth-2)  + " " + MonthNavigator.getYear(input: selectedMonth-2))", betrag: salesTotal(selectedMonth-2)-salesPayed(selectedMonth-2), color: "Noch nicht gezahlt"),
                                    
                                    .init(name: "\(MonthNavigator.getMonth(input: selectedMonth-1)  + " " + MonthNavigator.getYear(input: selectedMonth-1))", betrag: salesPayed(selectedMonth-1), color: "Gezahlt"),
                                    .init(name: "\(MonthNavigator.getMonth(input: selectedMonth-1)  + " " + MonthNavigator.getYear(input: selectedMonth-1))", betrag: salesTotal(selectedMonth-1)-salesPayed(selectedMonth-1), color: "Noch nicht gezahlt"),
                                    
                                    
                                    .init(name: "\(MonthNavigator.getMonth(input: selectedMonth)  + " " + MonthNavigator.getYear(input: selectedMonth))", betrag: salesPayed(selectedMonth), color: "Ausgewählt"),
                                    .init(name: "\(MonthNavigator.getMonth(input: selectedMonth)  + " " + MonthNavigator.getYear(input: selectedMonth))", betrag: salesTotal(selectedMonth)-salesPayed(selectedMonth), color: "Noch nicht gezahlt")
                                ]
                                ForEach(data) { pos in
                                    BarMark(x: .value("Monate", pos.name),
                                            y: .value("Umsatz", pos.betrag + 0)
                                    )
                                    .foregroundStyle(by: .value("Beschreibung", pos.color))
                                    .annotation(position: .overlay, alignment: .center){
                                        
                                        AmountText(betrag: pos.betrag)
                                    }
                                }
                            }.chartForegroundStyleScale([
                                "Noch nicht gezahlt": .red, "Gezahlt": .teal, "Ausgewählt": .blue
                            ])
                            .chartYScale(domain: 0...300)
                        }.padding()
                            .frame(width: geo.size.width/2.25)
                    }
                    VStack(spacing: 7.5){
                        ForEach(students, id: \.self){ student in
                            HStack{
                                Text(student.surname + " " + student.name)
                                Spacer()
                                Text(salesPerStudent(student, selectedMonth: selectedMonth).formatted(.currency(code: "EUR")))
                            }.font(.body)
                        }
                        Divider()
                        HStack{
                            Text("Gesamt")
                            Spacer()
                            Text(salesTotal(selectedMonth).formatted(.currency(code: "EUR")))
                        }.font(.body.weight(.bold))
                        Spacer()
                    }.padding()
                    .frame(width: geo.size.width/2)
                }
            }.padding()
        }
    }
    func salesPerStudent(_ student: Student, selectedMonth: Int, showAll: Bool = true)->Double{
        var sales = 0.0
        let costsPerMinute = Double(student.payment)/60.0
        if !showAllSales{
            let startOfMonth = MonthNavigator.getDateFromComponents(month: selectedMonth).startOfMonth()
            let endOfMonth = MonthNavigator.getDateFromComponents(month: selectedMonth).endOfMonth()
            var filter = ""
            if showAll{
                filter = "date > %@ && date < %@"
            } else {
                filter = "date > %@ && date < %@ && isPayed = true"
            }
            for lesson in student.lessons.filter(filter, startOfMonth as CVarArg, endOfMonth as CVarArg){
                sales += costsPerMinute * Double(lesson.duration)
            }
        } else {
            for lesson in student.lessons{
                sales += costsPerMinute * Double(lesson.duration)
            }
        }
        return sales
    }
    
    func salesTotal(_ selectedMonth: Int)->Double{
        var sales = 0.0
        for student in students{
            sales += salesPerStudent(student, selectedMonth: selectedMonth)
        }
        return sales
    }
    func salesPayed(_ selectedMonth: Int)->Double{
        var sales = 0.0
        for student in students{
            sales += salesPerStudent(student, selectedMonth: selectedMonth, showAll: false)
        }
        return sales
    }
}

struct AmountText: View{
    let betrag: Double
    var body: some View{
        if betrag != 0.0{
            Text(betrag.formatted(.currency(code: "EUR")))
                    .foregroundColor(.white)
                    .font(.callout)
        }
    }
}

struct SalesPosition: Identifiable{
    var name: String
    var betrag: Double
    var id: UUID = UUID()
    var color: String
}

extension Date {
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
}
