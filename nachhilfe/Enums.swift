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
    case lessons, exams
    
    var name: String{
        switch self {
        case .lessons:
            return "Nachhilfestunden"
		case .exams:
			return "Klausuren"
        }
    }
    
    var image: String{
        switch self {
        case .lessons:
            return "clock"
		case .exams:
			return "doc"
        }
    }
} 
