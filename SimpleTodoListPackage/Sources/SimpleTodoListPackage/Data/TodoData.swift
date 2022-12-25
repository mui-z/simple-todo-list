//
//  File.swift
//  
//
//  Created by osushi on 2022/12/25.
//

import Foundation
import RealmSwift

final class TodoData: Object, ObjectKeyIdentifiable {
	@Persisted(primaryKey: true) var id: String
	@Persisted var title: String
	@Persisted var isDone: Bool
	
	override init() {
		super.init()
	}
	
	convenience init(id: String, title: String, isDone: Bool) {
		self.init()
		self.id = id
		self.title = title
		self.isDone = isDone
	}
}
