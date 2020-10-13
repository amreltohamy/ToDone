//
//  CategoryTableViewController.swift
//  ToDone
//
//  Created by MacBook on 10/13/20.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    var catagoryArray = [Categories]()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexpath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = catagoryArray[indexpath.row]
        }else{
            print("error gitting to indexpath fo selected row")
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catagoryArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = catagoryArray[indexPath.row].name
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
                context?.delete(catagoryArray[indexPath.row])
        catagoryArray.remove(at: indexPath.row)
        saveCategory()
    }


    @IBAction func addCategory(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alertController = UIAlertController(title: "Add Category", message: "add new category", preferredStyle: .alert)
        
        alertController.addTextField { (alertTextField) in
            alertTextField.placeholder = "crete new cat"
            textField = alertTextField
             
        }
        let alertAction = UIAlertAction(title: "ADD", style: .default) { (action) in
            let newCategory = Categories(context: self.context!)
            newCategory.name = textField.text
            self.catagoryArray.append(newCategory)
            self.saveCategory()
        }
        alertController.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        alertController.addAction(alertAction)
       
        present(alertController, animated: true, completion: nil)
    }
    
    
    
    func saveCategory() {
        do {
            try context?.save()
            
        } catch  {
            print(error.localizedDescription)
        }
        tableView.reloadData()
    }
    
    
    
    func loadCategories(with request:NSFetchRequest<Categories>  = Categories.fetchRequest()){
        do {
            catagoryArray = try context!.fetch(request)
            tableView.reloadData()

        }catch{
            print(error.localizedDescription)
        }
    }
    
}
    

