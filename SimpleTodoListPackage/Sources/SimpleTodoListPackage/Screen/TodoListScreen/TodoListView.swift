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
			Spacer()
				.frame(height: 20.0)

			Picker(selection: $viewModel.binding.selectedTodoState, label: Text("Picker")) {
				Text("Todo").tag(SelectedTodoState.list)
				Text("Done").tag(SelectedTodoState.done)
			}
			.pickerStyle(.segmented)

			if viewModel.output.todoList.value.isEmpty {
				Spacer()
				Text("Nothing Todo!")
				Spacer()
			} else {
				List {
					ForEach(viewModel.output.todoList.value, id: \.id) { todo in
						HStack {
							Text(todo.title)
								.padding(.horizontal)
							Spacer()
						}
						.contentShape(Rectangle())
						.onTapGesture {
							print("on tapped \(todo.title)")
						}
					}
					.onDelete { indexSet in
						if let index = indexSet.first {
							viewModel.input.didDeleteTodo.send(index)
						}
					}
				}
			}
		}
		.padding()
		.sheet(isPresented: $viewModel.binding.isShownAddModal, onDismiss: {
			viewModel.input.didCloseModal.send(())
		}, content: {
			AddTodoView(viewModel: .init(), environment: .init())
		})
		.toolbar {
			Button {
				viewModel.input.didTapAddTodoButton.send(())
			} label: {
				Image(systemName: "plus")
			}
		}

	}
}

struct TodoListView_Previews: PreviewProvider {
	static var previews: some View {
		TodoListView(viewModel: .init(), environment: .init())
	}
}
