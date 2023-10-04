//
//  ContentView.swift
//  Expense-SwiftData
//
//  Created by Jaimin Raval on 03/10/23.
//

import SwiftUI
import SwiftData
struct ContentView: View {
    //    SwiftData Context
    @Environment(\.modelContext) var context
    
    @State private var isShowingItemSheet = false
    @Query(sort: \Expense.date) var expenses: [Expense]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(expenses) { expense in
                    ExpenseCell(expenseData: expense)
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        context.delete(expenses[index])
                    }
                }
            }
            .navigationTitle("Tracky")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $isShowingItemSheet) { AddExpenseSheet() }
            .toolbar {
                if !expenses.isEmpty {
                    Button("Add Expense", systemImage: "plus") {
                        isShowingItemSheet = true
                    }
                }
            }
            .overlay {
                if expenses.isEmpty {
                    ContentUnavailableView(
                        label: {
                            Label("No Expenses", systemImage: "list.bullet.rectangle.portrait")
                        },
                        description: {
                            Text("Start adding expenses to see your list.")
                        },actions: {
                            Button("Add Expense") { isShowingItemSheet = true }
                            
                        }).offset(y: -60)
                }
            }
        }
    }
}

#Preview { ContentView() }

struct ExpenseCell: View {
    
    let expenseData: Expense
    
    var body: some View {
        HStack {
            Text(expenseData.date, format: .dateTime.month(.abbreviated).day())
                .frame(width: 70, alignment: .leading)
            Text(expenseData.name)
            Spacer()
            Text(expenseData.value, format: .currency(code: "INR"))
        }
    }
}


struct AddExpenseSheet: View {
//    SwiftData Context
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String = ""
    @State private var date: Date = .now
    @State private var value: Double = 0
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Expense Name", text: $name)
                DatePicker("Date", selection: $date, displayedComponents: .date)
                TextField("Value", value: $value, format: .currency(code: "INR"))
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("New Expense")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("Add") {
                        // Save code goes here
                        let expense = Expense(name: name, date: date, value: value)
                        // Saving data into our context
                        context.insert(expense)
                        dismiss()
                        // SwiftData have AutoSave feature which save all the context Data to our Persistant Container automatically after some time or any view update in our UI Hierarchy
                        // but we can save it explicitly if we want to like this:
//                        do {
//                            try context.save()
//                        } catch {
//                            // catch exception here
//                            
//                        }
                        
                    }
                }
            }
        }
    }
}



//  This project is created to learn SwiftData, Apple's latest Database Storage solution other than CoreData.
//  Minimum requirements for SwiftData: iOS & iPadOS 17 and macOS Sonoma
//  SwiftData brings everything in place for swift, swiftUI and UIKit
//  From Xcode 15.0 you can choose


