//
//  TodoListTest.swift
//  
//
//  Created by osushi on 2022/12/25.
//

import XCTest
@testable import SimpleTodoListPackage

// MARK: Test
final class TodoListTest: XCTestCase {
	func testDidTapTodo() {
		let viewModel = TodoListViewModel(repository: TodoRepositoryProtocolMock())

		let todo = Todo(title: "todo")

		XCTAssertNil(viewModel.output.modalModel)
		XCTAssertFalse(viewModel.binding.isShownEditModal)

		viewModel.input.didTapTodo.send(todo)

		XCTAssertEqual(viewModel.output.modalModel, todo)
		XCTAssertTrue(viewModel.binding.isShownEditModal)
	}

	func testDidCloseButton_showEditModal() {
		let repository = TodoRepositoryProtocolMock()
		let viewModel = TodoListViewModel(repository: repository)

		let todo = Todo(title: "todo")

		viewModel.output.modalModel = todo
		viewModel.binding.isShownEditModal = true

		XCTAssertNotNil(viewModel.output.modalModel)
		XCTAssertTrue(viewModel.binding.isShownEditModal)

		viewModel.input.didCloseModal.send(())

		XCTAssertNil(viewModel.output.modalModel)
		XCTAssertFalse(viewModel.binding.isShownEditModal)
		XCTAssertEqual(repository.getAllCallCount, 2)
	}

	func testDidCloseButton_showAddTodoModal() {
		let repository = TodoRepositoryProtocolMock()
		let viewModel = TodoListViewModel(repository: repository)

		viewModel.binding.isShownAddModal = true

		XCTAssertTrue(viewModel.binding.isShownAddModal)

		viewModel.input.didCloseModal.send(())

		XCTAssertFalse(viewModel.binding.isShownAddModal)
		XCTAssertEqual(repository.getAllCallCount, 2)
	}

	func testDidTapAddTodoButton() {
		let viewModel = TodoListViewModel(repository: TodoRepositoryProtocolMock())

		viewModel.input.didTapAddTodoButton.send(())

		XCTAssertTrue(viewModel.binding.isShownAddModal)
	}

	func testDidDeleteTodo() {
		let repository = TodoRepositoryProtocolMock()
		let viewModel = TodoListViewModel(repository: repository)
		let expectation = expectation(description: "expectaiton")
		let todo: Todo = Todo(title: "test")
		var isFirst = true

		expectation.expectedFulfillmentCount = 2

		repository.getAllHandler = {
			return []
		}
		
		viewModel.output.todoList.send([todo])

		viewModel.output.todoList
			.sink { todoList in
				if isFirst {
					isFirst = false
					XCTAssertEqual(todoList, [todo])
					viewModel.input.didDeleteTodo.send(0)
				} else {
					XCTAssertEqual(todoList, [])
				}

				expectation.fulfill()
			}
			.store(in: &cancellables)
		
		waitForExpectations(timeout: 1) { error in
			if error == nil {
				XCTAssertEqual(repository.deleteCallCount, 1)
				XCTAssertEqual(repository.getAllCallCount, 2)
			} else {
				XCTFail()
			}
		}

	}

	func testSelectListSegment() {
		let mockRepository = TodoRepositoryProtocolMock()
		let expectation = expectation(description: "selected list segment")
		let viewModel = TodoListViewModel(repository: mockRepository)
		let listedTodo = [Todo(title: "list")]
		let doneListTodo = [Todo(title: "done", isDone: true)]

		expectation.expectedFulfillmentCount = 2

		mockRepository.getAllHandler = {
			return listedTodo + doneListTodo
		}

		XCTAssertEqual(viewModel.binding.selectedTodoState, .list)
		XCTAssertEqual(viewModel.output.todoList.value, [])

		viewModel.binding.selectedTodoState = .done

		viewModel.output.todoList
			.first()
			.sink { _ in
				XCTAssertEqual(viewModel.binding.selectedTodoState, .done)
				XCTAssertEqual(viewModel.output.todoList.value, doneListTodo)
				expectation.fulfill()
			}
			.store(in: &cancellables)

		viewModel.binding.selectedTodoState = .list

		viewModel.output.todoList
			.first()
			.sink { _ in
				XCTAssertEqual(viewModel.binding.selectedTodoState, .list)
				XCTAssertEqual(viewModel.output.todoList.value, listedTodo)
				expectation.fulfill()
			}
			.store(in: &cancellables)

		waitForExpectations(timeout: 1) { error in
			if error == nil {
				XCTAssertEqual(mockRepository.getAllCallCount, 3)
			} else {
				XCTFail()
			}
		}
	}
}
