//
//  File.swift
//  
//
//  Created by osushi on 2022/12/25.
//

import Foundation
import RealmSwift

/// @mockable
protocol TodoRepositoryProtocol {
	func create(todo: Todo)
	func getById(id: String) -> Todo
	func getAll() -> [Todo]
	func update(todo: Todo)
	func delete(todo: Todo)
}

final class TodoRepository: TodoRepositoryProtocol {
	func create(todo: Todo) {
		let realm = try! Realm()
		try! realm.write {
			realm.add(todo.toData())
		}
	}
	
	func getById(id: String) -> Todo {
		let realm = try! Realm()
		return realm.object(ofType: TodoData.self, forPrimaryKey: id)!.toEntity()
	}
	
	func getAll() -> [Todo] {
		let realm = try! Realm()
		return realm.objects(TodoData.self).map { $0.toEntity() }
	}
	
	func update(todo: Todo) {
		let realm = try! Realm()
		try! realm.write {
			realm.add(todo.toData(), update: .all)
		}
	}
	
	func delete(todo: Todo) {
		let realm = try! Realm()
		realm.delete(todo.toData())
	}
}
