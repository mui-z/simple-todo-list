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
	
	let repository: TodoRepository = .init()
	var todoList: [Todo] = []
	
	init(
		input: Input = .init(),
		output: Output = .init(),
		binding: Binding = .init()
	) {
		self.input = input
		self.output = output
		self.binding = binding
		super.init()
		bind(input: input, output: output, binding: binding)
	}
}

// MARK: - Property
extension TodoListViewModel {
	
	final class Input {
		let onAppear: PassthroughSubject<Void, Never>
		let didTapTodo: PassthroughSubject<Todo, Never>
		let didCloseModal: PassthroughSubject<Void, Never>
		
		init(
			onAppear: PassthroughSubject<Void, Never> = .init(),
			didTapTodo: PassthroughSubject<Todo, Never> = .init(),
			didCloseModal: PassthroughSubject<Void, Never> = .init()
		) {
			self.onAppear = onAppear
			self.didTapTodo = didTapTodo
			self.didCloseModal = didCloseModal
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
		@Published var selectedTodoState: SelectedState = .list
		@Published var isShownModal = false
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
		
		input.onAppear
			.sink { [unowned self] _ in
				let fetchedTodoList = repository.getAll()
				todoList = fetchedTodoList
				let filteredTodoList = todoList.filter { todo in
					switch binding.selectedTodoState {
					case .list:
						return todo.isDone == false
					case .done:
						return todo.isDone == true
					}
				}
				output.todoList.send(filteredTodoList)
			}
			.store(in: &cancellables)
		
		input.didTapTodo
			.sink { todo in
				binding.isShownModal = true
				output.modalModel = todo
			}
			.store(in: &cancellables)
		
		input.didCloseModal
			.sink {
				binding.isShownModal = false
				output.modalModel = nil
			}
			.store(in: &cancellables)
		
		binding.$selectedTodoState
			.sink { selectedState in
				// TODO: Get From Repository
				let displayList: [Todo] = []
//				switch selectedState {
//				case .list:
//				case .done:
//				}
				
				output.todoList.send(displayList)
			}
			.store(in: &cancellables)
	}
}

enum SelectedState {
	case list
	case done
}
