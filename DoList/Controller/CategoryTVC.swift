//
//  ViewController.swift
//  DoList
//
//  Created by Khater on 10/12/21.
//  Copyright © 2021 Khater. All rights reserved.
//

import UIKit
import CoreData


class CategoryTVC: SwipeTableViewController {
    
    var categoryArrya = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Do List"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addButtonPressed(_:)))
        
        tableView.rowHeight = 60.0
        
        loadData()
    }
    
    //MARK: - TableView Delegate and DataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArrya.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = categoryArrya[indexPath.row].name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToList", sender: self)
    }
    
    
    //MARK: - Delete Cell
    
    override func deleteCell(at indexPath: IndexPath){
        context.delete(categoryArrya[indexPath.row])
        categoryArrya.remove(at: indexPath.row)
        saveData()
    }
    
    
    //MARK: - Bar Item Add Button
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alart = UIAlertController(title: "Add Category", message: "Please Enter Category", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            if let text = textField.text{
                let newCategory = Category(context: self.context)
                newCategory.name = text
                self.categoryArrya.append(newCategory)
                self.saveData()
            }
            self.tableView.reloadData()
        }
        alart.addTextField { (text) in
            text.placeholder = " Category Name"
            textField = text
        }
        //Cancel button in Alert Message
        alart.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        alart.addAction(action)
        
        present(alart, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToList"{
            let destinationVC = segue.destination as! ListTVC
            if let indexPath = tableView.indexPathForSelectedRow{
                destinationVC.category = categoryArrya[indexPath.row]
            }
        }
    }
    
    
    //MARK: - Load and Save Data
    
    
    func loadData(with request: NSFetchRequest<Category> = Category.fetchRequest()){
        do{
            categoryArrya = try context.fetch(request)
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

