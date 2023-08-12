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

enum StudentListTypes{
	case lessons, exams
}

enum ViewTypes: CaseIterable{
    case calendar, salesHistory
    
    var name: String{
        switch self {
		case .calendar:
			return "Kalender"
		case .salesHistory:
			return "Umsatzhistorie"
			
        }
    }
    
    var image: String{
        switch self {
		case .calendar:
			return "calendar"
		case .salesHistory:
			return "eurosign"
        }
    }
} 
