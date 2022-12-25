//
//  TodoListView.swift
//  SimpleTodoList
//
//  Created by osushi on 2022/12/24.
//

import SwiftUI

struct TodoListView: View {
	@ObservedObject var viewModel: TodoListViewModel
	let environment: TodoListEnvironemnt
	
	var body: some View {
		VStack {
			Picker(selection: $viewModel.binding.selectedTodoState, label: Text("Picker")) {
				Text("Todo").tag(SelectedState.list)
				Text("Done").tag(SelectedState.done)
			}
			.pickerStyle(.segmented)

			List {
				ForEach(viewModel.output.todoList.value, id: \.id) { todo in
					Text(todo.title)
				}
			}
		}
		.padding()

	}
}

struct TodoListView_Previews: PreviewProvider {
	static var previews: some View {
		TodoListView(viewModel: .init(), environment: .init())
	}
}
