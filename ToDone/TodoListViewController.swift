 //
//  ViewController.swift
//  ToDone
//
//  Created by MacBook on 10/11/20.
//

import UIKit
//import CoreData
 import RealmSwift

class TodoListViewController: UITableViewController {
    
 
    @IBOutlet weak var searchbar: UISearchBar!
    var itemArray : Results<Item>?
    let realm = try? Realm()
    var selectedCategory : Categories? {
        didSet {
           loadRealmItems()
        }
    }
    //let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchbar.delegate = self
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = itemArray?[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = item?.title ?? "empty"
        cell.accessoryType = item?.done ?? false ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        

        if let item = itemArray?[indexPath.row] {
            do{
                try realm?.write{
                    item.done = !item.done
                }
            }catch{
                print(error.localizedDescription)
            }
           
        }
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
        
        
//        itemArray?[indexPath.row].done = !(itemArray?[indexPath.row].done ?? false)
//        //  saveItems()
        
   
    }
  
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if let item = itemArray?[indexPath.row] {
            do{
                try realm?.write{
                    realm?.delete(item)
                }
            }catch{
                print(error.localizedDescription)
            }
           
        }
        tableView.reloadData()
        
              //  context?.delete(itemArray[indexPath.row])
              //  itemArray.remove(at: indexPath.row)
              //  saveItems()
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
                
                if let currentCategory = self.selectedCategory{
                  
                    do {
                        try self.realm?.write(){
                            let newItem = Item()
                            newItem.title = textField.text!
                            newItem.done = false
                            newItem.dateCreated = Date()
                            currentCategory.items.append(newItem)
                           
                        }
                    } catch  {
                        print(error.localizedDescription)
                    }
                    self.tableView.reloadData()
                    
                }
              
                
                
                
             //   newItem.parentCatagory = self.selectedCategory
              //  self.itemArray.append(newItem)
              //  self.saveItems()
                
            }
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func loadRealmItems() {
        itemArray = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
    }
    
    
    //searchbar delegates
   
    
    
    
    
    
    

//    func saveItems() {
//        do {
//            try context?.save()
//
//        } catch  {
//            print(error.localizedDescription)
//        }
//        tableView.reloadData()
//    }
    
       
//    func loadItems(with request:NSFetchRequest<Item>  = Item.fetchRequest() , predicate : NSPredicate? = nil ){
//        let categoryPredicate = NSPredicate(format: "parentCatagory.name MATCHES %@", selectedCategory!.name!)
//        if let safePredicate = predicate {
//            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [safePredicate,categoryPredicate])
//            request.predicate = compoundPredicate
//        }else{
//            request.predicate = categoryPredicate
//        }
//
//        do {
//            itemArray = try context!.fetch(request)
//            tableView.reloadData()
//
//        }catch{
//            print(error.localizedDescription)
//        }
//    }
    
}
//MARK:- search bar methodes
extension TodoListViewController:UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        itemArray = itemArray?.filter( "title CONTAINS[cd] %@", searchbar.text!).sorted(byKeyPath: "dateCreated", ascending: false)
        tableView.reloadData()
        
        
        
        
//            let request : NSFetchRequest<Item> = Item.fetchRequest()
//            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchbar.text!)
//            loadItems(with: request,predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchbar.text?.count == 0 {
            
            
            loadRealmItems()
            tableView.reloadData()
        //    loadItems()
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
