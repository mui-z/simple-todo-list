//
//  Todo.swift
//  SimpleTodoList
//
//  Created by osushi on 2022/12/24.
//

import Foundation

struct Todo: Equatable, Identifiable {
	let id = UUID()
	let name: String
	let isDone: Bool
	
	init(name: String, isDone: Bool = false) {
		self.name = name
		self.isDone = isDone
	}
}
