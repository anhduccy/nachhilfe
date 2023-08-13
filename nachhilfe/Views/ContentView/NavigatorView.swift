//
//  NavigatorView.swift
//  nachhilfe
//
//  Created by anh :) on 14.08.22.
//

import SwiftUI
import Realm
import RealmSwift
import UIKit

struct NavigatorView: View{
	@ObservedResults(Student.self) var students
	
	@State var selectedView: ViewTypes? = .calendar
	
	@State var showStudentEditView: Bool = false
	@State var showSettingsView: Bool = false
	
	var body: some View{
		NavigationSplitView(sidebar: {
			List(selection: $selectedView){
				ForEach(ViewTypes.allCases, id: \.self){ view in
					NavigationLink(value: view, label: {Label(view.name, systemImage: view.image)})
				}
				if !students.isEmpty{
					Section("Alle Nachhilfeschüler", content: {
						ForEach(students.sorted(byKeyPath: "surname"), id: \.self){ student in
							NavigationLink(destination: StudentView(student: student), label: {
								Label(title: {Text("\(student.surname) \(student.name)")}, icon: {
									Image(systemName: "person")
								})
							})
						}
					})
				}
			}.toolbar{
				ToolbarItemGroup{
					 Button(action: {
						 showStudentEditView.toggle()
					 }, label: {
						 Image(systemName: "person.crop.circle.badge.plus")
					 }).sheet(isPresented: $showStudentEditView){
						 StudentEditView(type: .add, student: nil, isPresented: $showStudentEditView)
					 }
				
					Button(action: {
						showSettingsView.toggle()
					}, label: {
						Image(systemName: "gear")
					}).sheet(isPresented: $showSettingsView){
						SettingsView(isPresented: $showSettingsView)
					}
				}
		 }
		}, detail:{
			switch selectedView {
			case .salesHistory:
				SalesView()
			default:
				CalendarView()
			}
		})
		.onAppear{
			NotificationCenter.requestPermission()
		}
	}
}

/*FOR DEBUG
struct NotificationView: View{
	var body: some View{
		ForEach(notifications(), id: \.self){ notification in
			HStack{
				Text(notification.identifier)
				Spacer()
				Text("\(notification.trigger!.value(forKey: "date") as! Date)")
			}
		}
		
		ForEach(UIApplication.shared.scheduledLocalNotifications!, id: \.self){ not in
			HStack{
				Text(not.alertBody!)
				Spacer()
				Text("\(not.fireDate ?? Date())")
			}
		}
	}
	func notifications()->[UNNotificationRequest]{
		var array: [UNNotificationRequest] = []
		UNUserNotificationCenter.current().getPendingNotificationRequests{ (notifications) in
			for notification in notifications {
				array.append(notification)
			}
		}
		return array
	}
}
 */


