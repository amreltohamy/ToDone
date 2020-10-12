//
//  ViewController.swift
//  ToDone
//
//  Created by MacBook on 10/11/20.
//

import UIKit

class TodoListViewController: UITableViewController {
    
 
    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
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
        self.saveData()
        
        tableView.deselectRow(at: indexPath, animated: true)
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
                let newItem = Item()
                newItem.title = textField.text!
                self.itemArray.append(newItem)
                self.saveData()
             
              
            }
        }
       
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    func saveData()  {
        let encoder = PropertyListEncoder()
          do{
              let data = try encoder.encode(self.itemArray)
              try data.write(to: self.dataFilePath!)
          }catch{
              print("errror encoding ItemArray")
          }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }

       
    }
    func loadItems(){
     
        if let data = try? Data(contentsOf: dataFilePath!) {
                let decoder = PropertyListDecoder()
           try? itemArray = decoder.decode([Item].self, from: data)
                
            }
       
       
    }
    
}

