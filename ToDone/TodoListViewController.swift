//
//  ViewController.swift
//  ToDone
//
//  Created by MacBook on 10/11/20.
//

import UIKit

class TodoListViewController: UITableViewController {
    
 
    var itemArray = [Item]()

    override func viewDidLoad() {
        super.viewDidLoad()

        if let items = UserDefaults.standard.array(forKey: "itemArray") as? [Item] {
            itemArray = items
        }
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
        tableView.reloadData()
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
                UserDefaults.standard.setValue(self.itemArray, forKey: "itemArray")
              //  UserDefaults.standard.set(self.itemArray, forKey: "itemArray")
               
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
       
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}

