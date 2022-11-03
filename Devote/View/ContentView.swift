//
//  ContentView.swift
//  Devote
//
//  Created by Ege Aydemir on 29.10.2022.
//

import SwiftUI
import CoreData

struct ContentView: View {
    // MARK: - PROPERTY
    @State var task: String = ""
    
    @FocusState private var keyboardSaklama: Bool
    
    private var isButtonDisabled: Bool {
        task.isEmpty
    }
    
    // MARK: - Fetching DATA
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    
    // MARK: - FUNCTION
    
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            newItem.task = task
            newItem.completion = false
            newItem.id = UUID()
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    // MARK: - BODY
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    VStack(spacing: 16) {
                        TextField("New Task", text: $task)
                            .focused($keyboardSaklama)
                            .padding()
                            .background(
                                Color(UIColor.systemGray6)
                            )
                            .cornerRadius(10)
                        Button(action: {
                            addItem()
                            keyboardSaklama = false
                        }, label: {
                            Spacer()
                            Text("SAVE")
                            Spacer()
                        })
                        .disabled(isButtonDisabled)
                        .padding()
                        .font(.headline)
                        .foregroundColor(.white)
                        .background(isButtonDisabled ? Color.gray : Color.pink)
                        .cornerRadius(10)
                    } //:VSTACK
                    
                    .padding()
                    List {
                        ForEach(items) { item in
                            
                            VStack(alignment: .leading) {
                                Text(item.task ?? "")
                                    .font(.headline)
                                    .fontWeight(.bold
                                    )
                                Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }//:List Item
                        }
                        .onDelete(perform: deleteItems)
                    }//:LIST
                }//:VSTACK
                .navigationBarTitle("Daily Tasks", displayMode: .large)
                .toolbar {
                    #if os(iOS)
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                    #endif
                }//:TOOLBAR
                .background(backgroundGradient).ignoresSafeArea(.all)
            }//:ZSTACK
        }//:NAVIGATION
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
