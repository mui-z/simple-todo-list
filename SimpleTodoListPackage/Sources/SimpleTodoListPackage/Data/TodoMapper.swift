//
//  File.swift
//  
//
//  Created by osushi on 2022/12/25.
//

import Foundation

// MARK: - Mapper
extension Todo {
	func toData() -> TodoData {
		TodoData(id: self.id, title: self.title, isDone: self.isDone)
	}
}

extension TodoData {
	func toEntity() -> Todo {
		Todo(id: self.id, title: self.title, isDone: self.isDone)
	}
}
