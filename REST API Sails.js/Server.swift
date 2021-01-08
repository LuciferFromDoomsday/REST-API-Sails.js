//
//  Server.swift
//  REST API Sails.js
//
//  Created by admin on 1/8/21.
//

import Foundation
import SwiftUI

class Server : ObservableObject{
    @Published var tasks : [Task] = []
    @Published var noData = false
    let url = "http://localhost:1337/task"
    
    init() {
        getTasks()
    }
    
    func setTask(title : String , description : String){
        
        let session = URLSession(configuration: .default)
        
        var request = URLRequest(url:  URL(string: url)!)
        
        request.httpMethod = "POST"
        
        // adding header values
        
        request.addValue(title, forHTTPHeaderField: "title")
        request.addValue(description, forHTTPHeaderField: "description")
        
        session.dataTask(with: request){ (data , _ , err) in
            
            if(err != nil){
                print((err?.localizedDescription)!)
            }
            
            guard let responce = data else{return}
            
            let status = String(data: responce , encoding: .utf8) ?? ""
            
           
            
            if status == "Added succesfully"{
                self.getTasks()
            }
            else{
                print(status)
                print("Failed adding")
            }
            
            
        }.resume()
        
    }
    func getTasks(){
        
        
        var request = URLRequest(url:  URL(string: url)!)
        
        request.httpMethod = "GET"
        
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: request){ (data , _ , err) in
            
            if(err != nil){
                print((err?.localizedDescription)!)
                self.noData.toggle()
            }
            
            guard let responce = data else{return}
            
            let tasks = try! JSONDecoder().decode([Task].self , from: responce)
            
            DispatchQueue.main.async {
                self.tasks = tasks
                if tasks.isEmpty{ self.noData.toggle()}
            }
        
        }.resume()
        
    }
    
    func deleteTask(id : Int){

        var request = URLRequest(url:  URL(string: url)!)

        request.httpMethod = "DELETE"

        request.addValue("\(id)", forHTTPHeaderField: "id")
        

        let session = URLSession(configuration: .default)

        session.dataTask(with: request){ (data , _ , err) in
            
            if(err != nil){
                print((err?.localizedDescription)!)
            }

            guard let responce = data else{
                print("responce failed")
                return}
            
  
            let status = String(data: responce , encoding: .utf8) ?? ""
            
            if(status == "Deleted Successfully"){
                DispatchQueue.main.async {
                    self.tasks.removeAll{ (task) -> Bool in
                        print("Deleted")
                        return task.id == id
                       
                    }
                }
              
            }
            else{
                print("Failed deleting")
            }
            
            
        
    }.resume()
       
    }
    
    func newTask(){
        
        let alert = UIAlertController(title: "Add Task", message: "Write Your deals", preferredStyle: .alert)
        
        alert.addTextField() { (task) in
            task.placeholder = "Title"
        
        }
        alert.addTextField() { (task) in
            task.placeholder = "Description"
      
        }
        alert.addAction(UIAlertAction(title: "Cancel", style:.destructive ))
        
        alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { (_) in
            
            self.setTask(title: alert.textFields![0].text!, description: alert.textFields![1].text!)
          
            
            
        }))
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true)
    }
    
    
}
