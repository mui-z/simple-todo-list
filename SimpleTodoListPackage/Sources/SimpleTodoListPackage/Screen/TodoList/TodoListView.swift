//
//  TodoListView.swift
//  SimpleTodoList
//
//  Created by osushi on 2022/12/24.
//

import SwiftUI

struct TodoListView: View {
	var body: some View {
		VStack {
			Picker(selection: .constant(1), label: Text("Picker")) {
				Text("Todo").tag(1)
				Text("Done").tag(2)
				
			}
			.pickerStyle(.segmented)
			
			List {
				Text("A List Item")
				Text("A List Item")
					.onTapGesture {
						print(UUID().uuidString)
					}
				Text("A third a")
				
			}
			
		}
		.padding()
		
	}
}

struct TodoListView_Previews: PreviewProvider {
	static var previews: some View {
		TodoListView()
	}
}
