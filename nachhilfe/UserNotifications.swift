//
//  UserNotifications.swift
//  nachhilfe
//
//  Created by anh :) on 13.08.23.
//

import UserNotifications
import RealmSwift
import Realm

class NotificationCenter{
    static func requestPermission(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]){ success, error in
            if success {
                print("Notification ON")
            } else if let error = error {
                print("Notification ERROR: \(error.localizedDescription)")
            }
        }
    }
    
    static func combineDateTime(date: Date) -> DateComponents{
        let storageTime = UserDefaults.standard.string(forKey: "notificationTime") ?? "20:00"
        let time = Date(timeIntervalSinceReferenceDate: Double(storageTime) ?? 0.0)
                
        let timeComponents: DateComponents = Calendar.current.dateComponents([.hour,.minute,.second,.timeZone], from: time)
        let dateComponents: DateComponents = Calendar.current.dateComponents([.year,.month,.day], from: date)
        let combinedDate: DateComponents = .init(calendar: .current, timeZone: timeComponents.timeZone, year: dateComponents.year, month: dateComponents.month, day: dateComponents.day, hour: timeComponents.hour, minute: timeComponents.minute, second: timeComponents.second)
        return combinedDate
    }
    
    static func scheduleExam(exam: ExamModel){
        let date = combineDateTime(date: exam.date.addingTimeInterval(-60*60*24))
        
        let content = UNMutableNotificationContent()
        content.title = "Klausur morgen"
        content.body = "\(exam.student.surname) \(exam.student.name)"
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: false)
        let request = UNNotificationRequest(identifier: "\(exam.student._id)-\(exam._id)-exams", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
        print("Add Exam notification on \(date)")
    }
    
    static func scheduleLesson(lesson: LessonModel){
        let date = combineDateTime(date: lesson.date.addingTimeInterval(-60*60*24))
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let time = dateFormatter.string(from: lesson.date)
        
        let content = UNMutableNotificationContent()
        content.title = "Nachhilfestunde morgen"
        content.body = "Du hast morgen eine Nachhilfestunde mit \(lesson.student.surname) \(lesson.student.name) um \(time)"
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: false)
        let request = UNNotificationRequest(identifier: "\(lesson.student._id)-\(lesson._id)-lessons", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
        print("Add Lesson notification on \(date)")
    }
    
    static func deleteNotification(studentID: String, objID: String, type: String){
        let identifier = "\(studentID)|\(objID)-\(type)"
        deleteNotification(id: identifier)
    }
    
    static func deleteNotification(id: String){
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [id])
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
        print("Delete Notification \(id)")
    }
    
    static func updateAllNotifications(){
        UNUserNotificationCenter.current().getPendingNotificationRequests{ (notifications) in
            for notification in notifications{
                deleteNotification(id: notification.identifier)
                let identifier = notification.identifier.components(separatedBy: "-")
                if identifier.last! == "lessons"{
                    DispatchQueue.main.async {
                        do {
                            let id = try ObjectId(string: identifier[1])
                            let lessonObj = realmEnv.object(ofType: Lesson.self, forPrimaryKey: id)
                            let model = LessonModel().toLayer(lesson: lessonObj!)
                            scheduleLesson(lesson: model)
                        } catch {
                           print("identifier[1] invalid, try failed")
                        }
                        
                    }
                }
                if identifier.last! == "exams"{
                    DispatchQueue.main.async {
                        do {
                            let id = try ObjectId(string: identifier[1])
                            let examObj = realmEnv.object(ofType: Exam.self, forPrimaryKey: id)
                            let model = ExamModel().toLayer(exam: examObj!)
                            scheduleExam(exam: model)
                        } catch {
                           print("identifier[1] invalid, try failed")
                        }
                    }
                }
            }
        }
    }
    
    static func reset(){
        UNUserNotificationCenter.current().getPendingNotificationRequests{ (notifications) in
            for notification in notifications {
                deleteNotification(id: notification.identifier)
            }
        }
        UNUserNotificationCenter.current().getDeliveredNotifications{ (notifications) in
            for notification in notifications {
                deleteNotification(id: notification.request.identifier)
            }
        }
    }
}
