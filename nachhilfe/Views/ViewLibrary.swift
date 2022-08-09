//
//  ViewLibrary.swift
//  nachhilfe
//
//  Created by anh :) on 09.08.22.
//

import SwiftUI

struct LeftText: View{
    init(_ text: String, font: Font, fontWeight: Font.Weight){
        self.text = text
        self.font = font
        self.fontWeight = fontWeight
    }
    let text: String
    let font: Font
    let fontWeight: Font.Weight

    var body: some View{
        HStack{
            Text(text)
                .font(font)
                .fontWeight(fontWeight)
            Spacer()
        }
    }
}

struct Icon: View{
    init(systemName: String, color: Color = .teal, size: CGFloat = 30){
        self.systemName = systemName
        self.color = color
        self.size = size
    }
    let systemName: String
    let color: Color
    let size: CGFloat
    
    var body: some View{
        ZStack{
            Circle()
                .fill(color)
                .opacity(0.2)
                .frame(width: size, height: size)
            Image(systemName: systemName)
                .resizable()
                .scaledToFit()
                .frame(width: size/2)
                .foregroundColor(color)
        }
    }
}
