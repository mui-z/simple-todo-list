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
							viewModel.input.didTapTodoCell.send(todo)
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
		.confirmationDialog(
			"Menu",
			isPresented: $viewModel.binding.isShownActionSheet,
			presenting: viewModel.output.modalModel,
			actions: { targetTodo in
				if viewModel.binding.selectedTodoState == .list {
					Button("Done"){
						viewModel.input.didTapDoneButton.send(targetTodo)
					}
				}
				Button("Delete", role: .destructive){
					viewModel.input.didTapDeleteButton.send(targetTodo)
				}
				Button("Cancel", role: .cancel) {
					viewModel.binding.isShownActionSheet = false
				}
			},
			message: { targetTodo in
				Text("edit todo.")
			}
		)
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
