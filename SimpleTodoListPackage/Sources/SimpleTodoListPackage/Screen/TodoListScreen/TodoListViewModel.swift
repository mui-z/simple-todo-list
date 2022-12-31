//
//  TodoListViewModel.swift
//  SimpleTodoList
//
//  Created by osushi on 2022/12/24.
//

import Foundation
import CombineStorable
import Combine
import SwiftUI

// MARK: - ViewModel
final class TodoListViewModel: NSObject, ObservableObject, Storable {
	let input: Input
	let output: Output
	@ObservedObject var binding: Binding
	
	let repository: TodoRepositoryProtocol
	
	init(
		input: Input = .init(),
		output: Output = .init(),
		binding: Binding = .init(),
		repository: TodoRepositoryProtocol = TodoRepository()
	) {
		self.input = input
		self.output = output
		self.binding = binding
		self.repository = repository
		super.init()
		bind(input: input, output: output, binding: binding)
	}
}

// MARK: - Property
extension TodoListViewModel {
	
	final class Input {
		let didTapTodoCell: PassthroughSubject<Todo, Never>
		let didCloseModal: PassthroughSubject<Void, Never>
		let didTapDoneButton: PassthroughSubject<Todo, Never>
		let didTapAddTodoButton: PassthroughSubject<Void, Never>
		let didTapDeleteButton: PassthroughSubject<Todo, Never>
		
		init(
			didTapTodoCell: PassthroughSubject<Todo, Never> = .init(),
			didCloseModal: PassthroughSubject<Void, Never> = .init(),
			didTapDoneButton: PassthroughSubject<Todo, Never> = .init(),
			didTapAddTodoButton: PassthroughSubject<Void, Never> = .init(),
			didDeleteTodo: PassthroughSubject<Todo, Never> = .init()
		) {
			self.didTapTodoCell = didTapTodoCell
			self.didCloseModal = didCloseModal
			self.didTapDoneButton = didTapDoneButton
			self.didTapAddTodoButton = didTapAddTodoButton
			self.didTapDeleteButton = didDeleteTodo
		}
	}
	
	final class Output: ObservableObject {
		var modalModel: Todo?
		let dismissView: PassthroughSubject<Void, Never>
		let todoList: CurrentValueSubject<[Todo], Never>
		
		init(
			modalModel: Todo? = nil,
			dismissView: PassthroughSubject<Void, Never> = .init(),
			todoList: CurrentValueSubject<[Todo], Never> = .init([Todo(title: "1st todo"), Todo(title: "2nd todo"), Todo(title: "3rd todo")])
		) {
			self.modalModel = modalModel
			self.dismissView = dismissView
			self.todoList = todoList
		}
	}
	
	final class Binding: ObservableObject {
		@Published var selectedTodoState: SelectedTodoState = .list
		@Published var isShownAddModal = false
		@Published var isShownActionSheet = false
	}
}

// MARK: - Private
private extension TodoListViewModel {
	func bind(input: Input, output: Output, binding: Binding) {
		binding.objectWillChange
			.sink { [weak self] _ in
				self?.objectWillChange.send()
			}
			.store(in: &cancellables)
		
		input.didTapTodoCell
			.sink { todo in
				binding.isShownActionSheet = true
				output.modalModel = todo
			}
			.store(in: &cancellables)
		
		input.didCloseModal
			.sink { [unowned self] _ in
				binding.isShownActionSheet = false
				binding.isShownAddModal = false
				output.modalModel = nil
				output.todoList.send(getFilteredTodoList(selectedTodoState: binding.selectedTodoState))
			}
			.store(in: &cancellables)
		
		input.didTapDoneButton
			.sink { [unowned self] todo in
				let updatedTodo = Todo(id: todo.id, title: todo.title, isDone: true)
				self.repository.update(todo: updatedTodo)
				output.todoList.send(getFilteredTodoList(selectedTodoState: binding.selectedTodoState))
			}
			.store(in: &cancellables)
		
		input.didTapAddTodoButton
			.sink { _ in
				binding.isShownAddModal = true
			}
			.store(in: &cancellables)
		
		input.didTapDeleteButton
			.sink { [unowned self] todo in
				repository.delete(todo: todo)
				output.todoList.send(getFilteredTodoList(selectedTodoState: binding.selectedTodoState))
			}
			.store(in: &cancellables)
		
		binding.$selectedTodoState
			.sink { [unowned self] selectedState in
				output.todoList.send(getFilteredTodoList(selectedTodoState: selectedState))
			}
			.store(in: &cancellables)
	}
	
	private func filterTodoList(todo: Todo, selectedState: SelectedTodoState) -> Bool {
		switch selectedState {
		case .list:
			return !todo.isDone
		case .done:
			return todo.isDone
		}
	}
	
	private func getFilteredTodoList(selectedTodoState: SelectedTodoState) -> [Todo] {
		repository.getAll()
			.filter { filterTodoList(todo: $0, selectedState: selectedTodoState) }
	}
}

enum SelectedTodoState {
	case list
	case done
}
