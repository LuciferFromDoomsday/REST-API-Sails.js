//
//  ContentView.swift
//  REST API Sails.js
//
//  Created by admin on 1/7/21.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        NavigationView{
            Home().navigationTitle("ToDoList With Rest")
        }

    
    }
    
}


struct Home: View {
    @StateObject var data = Server()
    
    var body: some View {
        
        VStack{
            
            if data.tasks.isEmpty{
                if data.noData{Text("No Tasks here yet")}
                else {ProgressView()}
                
            }
            else{
                List{
                    
                    ForEach(data.tasks, id : \.id){ task in
                        
                        VStack(alignment: .leading, spacing: 10 ){
                            
                            Text(task.title)
                                .fontWeight(.bold)
                            
                            Text(task.description)
                                .font(.caption)
                            
                            
                            
                        }
                        
                    }
                    .onDelete { (indexSet) in
                        
                        indexSet.forEach{ (index) in
                            print(data.tasks[index].id)
                            data.deleteTask(id: data.tasks[index].id)
                            
                        }
                    }
                }
            }
            
        }
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing ){
                Button(action: data.newTask){
                    Text("Create")
                }
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
