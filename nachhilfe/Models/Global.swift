//
//  Global.swift
//  nachhilfe
//
//  Created by anh :) on 09.08.22.
//

import Foundation

class Global: ObservableObject{
    init(){
        username = ""
    }
    @Published var username: String
}
