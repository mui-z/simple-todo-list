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
		XCTAssertFalse(viewModel.binding.isShownModal)

		viewModel.input.didTapTodo.send(todo)

		XCTAssertEqual(viewModel.output.modalModel, todo)
		XCTAssertTrue(viewModel.binding.isShownModal)
	}

	func testDidCloseButton() {
		let viewModel = TodoListViewModel(repository: TodoRepositoryProtocolMock())

		let todo = Todo(title: "todo")

		viewModel.output.modalModel = todo
		viewModel.binding.isShownModal = true

		XCTAssertNotNil(viewModel.output.modalModel)
		XCTAssertTrue(viewModel.binding.isShownModal)

		viewModel.input.didCloseModal.send(())

		XCTAssertNil(viewModel.output.modalModel)
		XCTAssertFalse(viewModel.binding.isShownModal)
	}
	
	func testOnAppear() {
		let mockRepository = TodoRepositoryProtocolMock()
		let viewModel = TodoListViewModel(repository: mockRepository)
		let expectation = expectation(description: "on appear test")
		
		let listedTodo = [Todo(title: "list")]
		let doneListTodo = [Todo(title: "done", isDone: true)]
		
		expectation.expectedFulfillmentCount = 2
		
		mockRepository.getAllHandler = {
			return listedTodo + doneListTodo
		}
		
		viewModel.output.todoList
			.first()
			.sink { _ in
				XCTAssertEqual(viewModel.output.todoList.value, [])
				expectation.fulfill()
			}
			.store(in: &cancellables)
		
		viewModel.output.todoList
			.dropFirst()
			.sink { _ in
				XCTAssertEqual(viewModel.output.todoList.value, listedTodo)
				expectation.fulfill()
			}
			.store(in: &cancellables)
		
		viewModel.input.onAppear.send(())
		
		waitForExpectations(timeout: 1)
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
		
		waitForExpectations(timeout: 1)
	}
}
