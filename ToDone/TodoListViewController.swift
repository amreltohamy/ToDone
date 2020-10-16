 //
//  ViewController.swift
//  ToDone
//
//  Created by MacBook on 10/11/20.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
 
    @IBOutlet weak var searchbar: UISearchBar!
    var itemArray = [Item]()
    var selectedCategory : Categories? {
        didSet {
            loadItems()
        }
    }
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchbar.delegate = self
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = itemArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        

      
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
  
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
                context?.delete(itemArray[indexPath.row])
                itemArray.remove(at: indexPath.row)
                saveItems()
    }
    
    @IBAction func add(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "add new memo", message: "", preferredStyle: .alert)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "crete new item"
            textField = alertTextField
             
        }
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //after add
            if textField.text != nil {
                
                
                let newItem = Item(context: self.context!)
                newItem.title = textField.text!
                newItem.done = false
                newItem.parentCatagory = self.selectedCategory
                self.itemArray.append(newItem)
                self.saveItems()
                
            }
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    //searchbar delegates
   
    
    
    

    func saveItems() {
        do {
            try context?.save()
            
        } catch  {
            print(error.localizedDescription)
        }
        tableView.reloadData()
    }
    
    func loadItems(with request:NSFetchRequest<Item>  = Item.fetchRequest() , predicate : NSPredicate? = nil ){
        let categoryPredicate = NSPredicate(format: "parentCatagory.name MATCHES %@", selectedCategory!.name!)
        if let safePredicate = predicate {
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [safePredicate,categoryPredicate])
            request.predicate = compoundPredicate
        }else{
            request.predicate = categoryPredicate
        }
        
        do {
            itemArray = try context!.fetch(request)
            tableView.reloadData()

        }catch{
            print(error.localizedDescription)
        }
    }
    
}
//MARK:- search bar methodes
extension TodoListViewController:UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
       
            let request : NSFetchRequest<Item> = Item.fetchRequest()
            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchbar.text!)
            loadItems(with: request,predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchbar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                self.searchbar.resignFirstResponder()
            }
        }
    }
}



















//    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")


//    func saveData()  {
//        let encoder = PropertyListEncoder()
//          do{
//              let data = try encoder.encode(self.itemArray)
//              try data.write(to: self.dataFilePath!)
//          }catch{
//              print("errror encoding ItemArray")
//          }
//        DispatchQueue.main.async {
//            self.tableView.reloadData()
//        }
//
//
//    }
//    func loadItems(){
//
//        if let data = try? Data(contentsOf: dataFilePath!) {
//                let decoder = PropertyListDecoder()
//           try? itemArray = decoder.decode([Item].self, from: data)
//
//            }
//
//
//    }
