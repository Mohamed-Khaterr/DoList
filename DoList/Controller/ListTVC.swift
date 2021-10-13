//
//  ListTVC.swift
//  DoList
//
//  Created by Khater on 10/12/21.
//  Copyright © 2021 Khater. All rights reserved.
//

import UIKit
import CoreData

class ListTVC: SwipeTableViewController {
    
    var listArray = [Lists]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var category: Category?{
        didSet{
            loadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Lists"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addButtonPressed(_:)))
        
        tableView.rowHeight = 60.0
        
        loadData()
    }

    // MARK: - TableView DataSource and Delegate

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = listArray[indexPath.row].title
        
        cell.accessoryType = listArray[indexPath.row].done ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        listArray[indexPath.row].done = !listArray[indexPath.row].done
        
        saveData()
    }
    
    //MARK: - Delete list
    
    override func deleteCell(at indexPath: IndexPath){
        context.delete(listArray[indexPath.row])
        listArray.remove(at: indexPath.row)
        
        saveData()
    }
    
    //MARK: - Bar Item Add Button
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alart = UIAlertController(title: "Add item", message: "Please Enter Item", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            if let text = textField.text{
                let newList = Lists(context: self.context)
                newList.title = text
                newList.done = false
                //link the new list with the category name
                newList.parentCategory = self.category
                self.listArray.append(newList)
                self.saveData()
            }
            self.tableView.reloadData()
        }
        alart.addTextField { (text) in
            text.placeholder = " New Item"
            textField = text
        }
        //Cancel button in Alert Message
        alart.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        alart.addAction(action)
        
        present(alart, animated: true, completion: nil)
    }
    
    
    //MARK: - Load and Save Data
    
    func loadData(with request: NSFetchRequest<Lists> = Lists.fetchRequest()){
        if let name = category?.name{
            let predicat = NSPredicate(format: "parentCategory.name MATCHES %@", name)
            request.predicate = predicat
        }
        
        do{
            listArray = try context.fetch(request)
        } catch {
            print("Error! Fetch Request: \(error.localizedDescription)")
        }
        
        tableView.reloadData()
    }
    
    
    func saveData(){
        do{
            try context.save()
        }catch{
            print("Error! Save Data: \(error.localizedDescription)")
        }
        tableView.reloadData()
    }
}
