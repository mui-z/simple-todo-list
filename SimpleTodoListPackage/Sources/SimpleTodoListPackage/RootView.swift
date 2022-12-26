//
//  SwiftUIView.swift
//  
//
//  Created by osushi on 2022/03/05.
//

import SwiftUI
import HeliumLogger
import LoggerAPI

public struct RootView: View {

	public init() {
		HeliumLogger.use()
	}

	public var body: some View {
		NavigationStack {
			TodoListView(viewModel: .init(), environment: .init())
				.toolbar {
					Button {
						print("add button pressed!")
					} label: {
						Image(systemName: "plus")
					}
				}
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		RootView()
	}
}
