//
//  Todo.swift
//  SimpleTodoList
//
//  Created by osushi on 2022/12/24.
//

import Foundation

struct Todo: Equatable, Identifiable {
	let id: String
	let title: String
	let isDone: Bool

	init(title: String, isDone: Bool = false) {
		self.id = UUID().uuidString
		self.title = title
		self.isDone = isDone
	}
	
	init(id: String, title: String, isDone: Bool) {
		self.id = id
		self.title = title
		self.isDone = isDone
	}
}
