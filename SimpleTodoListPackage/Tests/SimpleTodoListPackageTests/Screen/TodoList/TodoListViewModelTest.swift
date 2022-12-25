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
		let viewModel = TodoListViewModel()

		let todo = Todo(title: "todo")

		XCTAssertNil(viewModel.output.modalModel)
		XCTAssertFalse(viewModel.binding.isShownModal)

		viewModel.input.didTapTodo.send(todo)

		XCTAssertEqual(viewModel.output.modalModel, todo)
		XCTAssertTrue(viewModel.binding.isShownModal)
	}

	func testDidCloseButton() {
		let viewModel = TodoListViewModel()

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
		let viewModel = TodoListViewModel()
		
		viewModel.input.onAppear.send(())
		
		XCTAssertEqual(viewModel.todoList, [])
	}

	func testSelectListSegment() {
		let viewModel = TodoListViewModel()

		XCTAssertEqual(viewModel.binding.selectedTodoState, .list)

		viewModel.binding.selectedTodoState = .done

		XCTAssertEqual(viewModel.binding.selectedTodoState, .done)
	}
}
