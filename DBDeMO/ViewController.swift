//
//  ViewController.swift
//  DBDeMO
//
//  Created by Mac on 12.08.20.
//  Copyright © 2020 peter. All rights reserved.
//

import UIKit
import SQLite
class ViewController: UIViewController {

    var database: Connection!
    
    let usersTable = Table("USERS")
    let id = Expression<Int>("id")
    let name = Expression<String>("name")
    let email = Expression<String>("email")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
        let documentDir = try FileManager.default.url(for: .documentationDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDir.appendingPathExtension("users").appendingPathExtension("sqlite3")
            let database =  try Connection(fileUrl.path)
            self.database = database
        } catch {
            print(error)
        }
        
    }
    
    @IBAction func createTable(_ sender: Any) {
        print("create Tapped")
        
        let createTable = self.usersTable.create {(table) in
            table.column(self.id, primaryKey: true)
            table.column(self.name)
            table.column(self.email, unique: true)
            
        }
        do {
            try self.database.run(createTable)
            print("CREATE TABLE")
        } catch {
            print(error)
        }
        
        
    }
    
    
    @IBAction func updateUser(_ sender: Any) {
        print("update")
        let alert = UIAlertController(title: "update user", message: nil, preferredStyle: .alert)
        alert.addTextField { (tf) in tf.placeholder = "Name" }
        alert.addTextField { (tf) in tf.placeholder = "Email" }
        let action = UIAlertAction(title: "Submit", style: .default) { (_) in
            guard let name = alert.textFields?.first?.text,
                let email = alert.textFields?.last?.text
                else { return }
            print(name)
            print(email)
            
            let user = self.usersTable.filter(self.name == name)
            let updateUser = user.update(self.email <- email)
            do {
              try  self.database.run(updateUser)
                print("user update")
            } catch {
                print(error)
            }
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func deleteUser(_ sender: Any) {
        print("delete users")
        let alert = UIAlertController(title: "delete user", message: nil, preferredStyle: .alert)
        alert.addTextField { (tf) in tf.placeholder = "UserId" }
        let action = UIAlertAction(title: "submit", style: .default) { (_) in
            guard let userIdString = alert.textFields?.first?.text,
            let idd = Int(userIdString)
            else { return }
            print(userIdString)
            
            let user = self.usersTable.filter(self.id == idd)
            let deleteUser = user.delete()
            do {
            try self.database.run(deleteUser)
            print("ok you delete")
            } catch {
                print(error)
            }
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    
    @IBAction func insertUser(_ sender: Any) {
        print("Insert user")
        
        let alert = UIAlertController(title: "Insert User", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (tf) in tf.placeholder = "Name" }
        alert.addTextField { (tf) in tf.placeholder = "Email" }
        
        let action = UIAlertAction(title: "Submit", style: .default) { (_) in
            guard let name = alert.textFields?.first?.text,
            let email = alert.textFields?.last?.text
            else   { return }
            print(name)
            print(email)
            
            let insertUser = self.usersTable.insert(self.name <- name,  self.email <- email)
            do {
                try self.database.run(insertUser)
                print("user inserted")
                
            } catch {
                print(error)
            }
            
    }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
  }
    
    
    
    @IBAction func listUsers(_ sender: Any) {
        print("LIST USERS")
        do {
            let allU = try self.database.prepare(self.usersTable)
           
            for user in allU {
                print("userId: \(user[self.id]), name: \(user[self.name]), email: \(user[self.email])")
            }
        } catch {
            print("all users error")
        }
    }
    
    

}
