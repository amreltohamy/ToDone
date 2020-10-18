//
//  CategoryTableViewController.swift
//  ToDone
//
//  Created by MacBook on 10/13/20.
//

import UIKit
//import CoreData
import RealmSwift 
import ChameleonFramework

class CategoryTableViewController: UITableViewController {
  
    
    
    
    
  //  let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext

    let realm = try? Realm()
    
    var catagoryArray : Results<Categories>?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 70
        loadRealmData()
        tableView.separatorStyle = .none
      //  loadCategories()
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexpath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = catagoryArray?[indexpath.row]
        }else{
            print("error gitting to indexpath fo selected row")
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catagoryArray?.count ?? 1
    }
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
//        cell.delegate = self
//        return cell
//    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = catagoryArray?[indexPath.row].name ?? "Empty"
       let color = UIColor(hexString: (catagoryArray?[indexPath.row].color)!)
        cell.backgroundColor = color
        cell.textLabel?.textColor = ContrastColorOf(color ?? .black, returnFlat: true)
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if let cat = catagoryArray?[indexPath.row] {
            do{
                try realm?.write{
                    realm?.delete(cat)
                }
            }catch{
                print(error.localizedDescription)
            }

        }
        tableView.reloadData()
             //   context?.delete(catagoryArray[indexPath.row])
    //     catagoryArray.remove(at: indexPath.row)
       // saveCategory()
    }


    @IBAction func addCategory(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alertController = UIAlertController(title: "Add Category", message: "add new category", preferredStyle: .alert)
        
        alertController.addTextField { (alertTextField) in
            alertTextField.placeholder = "create new cat"
            textField = alertTextField
             
        }
        let alertAction = UIAlertAction(title: "ADD", style: .default) { (action) in
            
            
            let newCategory = Categories()
            newCategory.name = textField.text!
            newCategory.color = UIColor.randomFlat().hexValue()
            self.saveRealmCategory(category: newCategory)
            
            
        // self.catagoryArray.append(newCategory)
         //self.saveCategory()
        }
        alertController.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        alertController.addAction(alertAction)
       
        present(alertController, animated: true, completion: nil)
    }
    
    
    func saveRealmCategory(category:Categories)  {
        do {
            try realm?.write(){
                realm?.add(category)
            }
        } catch  {
            print("error")
            print(error.localizedDescription)
        }
        tableView.reloadData()
    }
    
    func loadRealmData(){
        catagoryArray = realm?.objects(Categories.self)
        tableView.reloadData()
        
    }
    
  
   
//    func saveCategory() {
//        do {
//            try context?.save()
//
//        } catch  {
//            print(error.localizedDescription)
//        }
//        tableView.reloadData()
//    }
//
    
 
//    func loadCategories(with request:NSFetchRequest<Categories>  = Categories.fetchRequest()){
//        do {
//            catagoryArray = try context!.fetch(request)
//            tableView.reloadData()
//
//        }catch{
//            print(error.localizedDescription)
//        }
//    }
    
}
 

