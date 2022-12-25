//
//  SwiftUIView.swift
//  
//
//  Created by osushi on 2022/03/05.
//

import SwiftUI
import HeliumLogger
import LoggerAPI

public struct ContentView: View {

    public init() {
		HeliumLogger.use()
	}

    public var body: some View {
		TodoListView(viewModel: .init(), environment: .init())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
