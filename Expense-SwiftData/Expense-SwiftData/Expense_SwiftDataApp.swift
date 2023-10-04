//
//  Expense_SwiftDataApp.swift
//  Expense-SwiftData
//
//  Created by Jaimin Raval on 03/10/23.
//

import SwiftUI
import SwiftData

@main
struct Expense_SwiftDataApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Expense.self])
    }
}
