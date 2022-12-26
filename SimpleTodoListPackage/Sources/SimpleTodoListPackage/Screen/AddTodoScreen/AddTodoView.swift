//
//  SwiftUIView.swift
//  
//
//  Created by osushi on 2022/12/25.
//

import SwiftUI

struct AddTodoView: View {
	let viewModel: AddTodoViewModel
	let environment: AddTodoEnvironemnt
	
    var body: some View {
		VStack {
			Spacer()
			TextField("Add todo", text: viewModel.binding.$todoTitleText)
				.textFieldStyle(.roundedBorder)
				.padding(.horizontal, 40)
			
			Spacer()
				.frame(height: 50)
			
			Button("Register") {
				environment.dismiss()
			}

			Spacer()
		}
    }
}
