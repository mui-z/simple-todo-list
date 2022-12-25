//
//  SimpleTodoListApp.swift
//  SimpleTodoList
//
//  Created by osushi on 2022/03/05.
//

import SwiftUI
import SimpleTodoListPackage

@main
struct SimpleTodoListApp: App {
	@UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
			ContentView()
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate {
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {

		return true
	}
}
