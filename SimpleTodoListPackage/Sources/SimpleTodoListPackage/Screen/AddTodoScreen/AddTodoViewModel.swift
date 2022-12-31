//
//  File.swift
//  
//
//  Created by osushi on 2022/12/25.
//

import Foundation
import SwiftUI
import Combine
import CombineStorable

// MARK: - ViewModel
final class AddTodoViewModel: NSObject, ObservableObject, Storable {
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
extension AddTodoViewModel {
	final class Input {
		let didTapRegister: PassthroughSubject<Void, Never>

		init(didTapRegister: PassthroughSubject<Void, Never> = .init()) {
			self.didTapRegister = didTapRegister
		}
	}

	final class Output: ObservableObject {
		let dismissView: PassthroughSubject<Void, Never>
		let isEnabledRegisterButton: CurrentValueSubject<Bool, Never>

		init(
			dismissView: PassthroughSubject<Void, Never> = .init(),
			isRegisterButtonEnabled: CurrentValueSubject<Bool, Never> = .init(false)
		) {
			self.dismissView = dismissView
			self.isEnabledRegisterButton = isRegisterButtonEnabled
		}
	}

	final class Binding: ObservableObject {
		@Published var todoTitleText: String = ""
	}
}

// MARK: Private
private extension AddTodoViewModel {
	func bind(input: Input, output: Output, binding: Binding) {
		binding.objectWillChange
			.sink { [weak self] _ in
				self?.objectWillChange.send()
			}
			.store(in: &cancellables)

		input.didTapRegister
			.sink { [unowned self] _ in
				repository.create(todo: Todo(title: binding.todoTitleText))
				output.dismissView.send(())
			}
			.store(in: &cancellables)
		
		binding.$todoTitleText
			.sink { text in
				output.isEnabledRegisterButton.send(text.isEmpty == false)
			}
			.store(in: &cancellables)
	}
}
