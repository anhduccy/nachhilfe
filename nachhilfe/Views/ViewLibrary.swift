//
//  ViewLibrary.swift
//  nachhilfe
//
//  Created by anh :) on 09.08.22.
//

import SwiftUI
import UIKit
import Combine


/// Publisher to read keyboard changes.
protocol KeyboardReadable {
    var keyboardPublisher: AnyPublisher<Bool, Never> { get }
}

extension KeyboardReadable {
    var keyboardPublisher: AnyPublisher<Bool, Never> {
        Publishers.Merge(
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillShowNotification)
                .map { _ in true },
            
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillHideNotification)
                .map { _ in false }
        )
        .eraseToAnyPublisher()
    }
}


struct LeftText: View{
    init(_ text: String, font: Font = .body, fontWeight: Font.Weight = .regular){
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

struct GlassBackground: View {
    let width: CGFloat
    let height: CGFloat
    let color: Color

    var body: some View {
        ZStack{
            RadialGradient(colors: [.clear, color],
                           center: .center,
                           startRadius: 1,
                           endRadius: 100)
                .opacity(0.6)
            Rectangle().foregroundColor(color)
        }
        .opacity(0.2)
        .blur(radius: 2)
        .cornerRadius(15)
        .frame(width: width, height: height)
    }
}
