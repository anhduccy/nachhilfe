//
//  Enums.swift
//  nachhilfe
//
//  Created by anh :) on 10.08.22.
//

import Foundation

enum EditViewTypes{
    case add, edit
}

enum ViewTypes: CaseIterable{
    case home, lessons
    
    var name: String{
        switch self {
        case .home:
            return "Startseite"
        case .lessons:
            return "Stunden"
        }
    }
    
    var image: String{
        switch self {
        case .home:
            return "house"
        case .lessons:
            return "clock"
        }
    }
}
