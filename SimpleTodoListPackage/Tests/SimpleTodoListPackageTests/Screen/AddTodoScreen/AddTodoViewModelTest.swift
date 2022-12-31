//
//  AddTodoViewModelTest.swift
//  
//
//  Created by osushi on 2022/12/27.
//

import XCTest
import CombineStorable
@testable import SimpleTodoListPackage

final class AddTodoViewModelTest: XCTestCase, Storable {

	func testRegisterTodo() {
		let mockRepository = TodoRepositoryProtocolMock()
		let viewModel = AddTodoViewModel(repository: mockRepository)
		let expectation = expectation(description: "register todo")

		viewModel.output.dismissView
			.sink { _ in
				expectation.fulfill()
			}
			.store(in: &cancellables)

		viewModel.input.didTapRegister.send(())

		waitForExpectations(timeout: 1) { error in
			if error == nil {
				XCTAssertEqual(mockRepository.createCallCount, 1)
			} else {
				XCTFail()
			}
		}
	}
	
	func testIsEnabledRegisterButton() {
		let mockRepository = TodoRepositoryProtocolMock()
		let viewModel = AddTodoViewModel(repository: mockRepository)
		
		XCTAssertEqual(viewModel.output.isEnabledRegisterButton.value, false)
		
		viewModel.binding.todoTitleText = "input"
		XCTAssertEqual(viewModel.output.isEnabledRegisterButton.value, true)
		
		viewModel.binding.todoTitleText = ""
		XCTAssertEqual(viewModel.output.isEnabledRegisterButton.value, false)
	}
}
