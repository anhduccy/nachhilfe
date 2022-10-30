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

public func toggleSidebar() { // 2
    #if os(iOS)
    #else
    NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
    #endif
}
