//
//  NavigatorView.swift
//  nachhilfe
//
//  Created by anh :) on 14.08.22.
//

import SwiftUI

struct NavigatorView: View{
	@State var selectedView: ViewTypes? = .home
	
	var body: some View{
		NavigationSplitView(sidebar: {
			List(ViewTypes.allCases, id: \.self, selection: $selectedView){ view in
				NavigationLink(value: view, label: {Label(view.name, systemImage: view.image)})
			}
		}, detail: {
			switch selectedView {
			case .lessons:
				LessonsView()
			case .exams:
				ExamView()
			default:
				HomeView()
			}
		})
	}
}
