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
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
