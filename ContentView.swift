//
//  ContentView.swift
//  Todo
//
//  Created by Rohan Sanjeev on 16/03/23.
//

import SwiftUI

struct TodoItem: Identifiable {
    var id = UUID()
    var title: String
    var isCompleted = false
}

class TodoListViewModel: ObservableObject {
    @Published var todoItems = [TodoItem]()
    
    func addTodoItem(title: String) {
        let newTodoItem = TodoItem(title: title)
        todoItems.append(newTodoItem)
    }
    
    func toggleTodoItemCompleted(todoItem: TodoItem) {
        if let index = todoItems.firstIndex(where: { $0.id == todoItem.id }) {
            todoItems[index].isCompleted.toggle()
        }
    }
    
    func removeTodoItem(atOffsets offsets: IndexSet) {
        todoItems.remove(atOffsets: offsets)
    }
}

struct TodoListView: View {
    @ObservedObject var viewModel = TodoListViewModel()
    @State private var newTodoTitle = ""
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(viewModel.todoItems) { todoItem in
                        TodoListItemView(todoItem: todoItem, onToggleCompleted: viewModel.toggleTodoItemCompleted)
                    }
                    .onDelete(perform: viewModel.removeTodoItem)
                }
                .listStyle(.plain)
                
                HStack {
                    TextField("Add a new todo...", text: $newTodoTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button(action: {
                        viewModel.addTodoItem(title: newTodoTitle)
                        newTodoTitle = ""
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                    .disabled(newTodoTitle.isEmpty)
                }
                .padding()
            }
            .navigationBarTitle("Todo List")
        }
    }
}

struct TodoListItemView: View {
    let todoItem: TodoItem
    let onToggleCompleted: (TodoItem) -> Void
    
    var body: some View {
        Button(action: {
            onToggleCompleted(todoItem)
        }) {
            HStack {
                Image(systemName: todoItem.isCompleted ? "checkmark.circle.fill" : "circle")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(todoItem.isCompleted ? .green : .primary)
                
                Text(todoItem.title)
                    .strikethrough(todoItem.isCompleted)
            }
        }
    }
}
