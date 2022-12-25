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
    case lessons, exams, salesHistory
    
    var name: String{
        switch self {
        case .lessons:
            return "Nachhilfestunden"
		case .exams:
			return "Klausuren"
		case .salesHistory:
			return "Umsatzhistorie"
			
        }
    }
    
    var image: String{
        switch self {
        case .lessons:
            return "clock"
		case .exams:
			return "doc"
		case .salesHistory:
			return "eurosign"
        }
    }
} 
