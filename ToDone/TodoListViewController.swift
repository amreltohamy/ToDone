//
//  ViewController.swift
//  ToDone
//
//  Created by MacBook on 10/11/20.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = ["kil bill","visit ahmed","add frind","hello"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       if tableView.cellForRow(at: indexPath)?.accessoryType
            == .checkmark {
        tableView.cellForRow(at: indexPath)?.accessoryType
            = .none
       }else{
        tableView.cellForRow(at: indexPath)?.accessoryType
            = .checkmark
       }
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
                self.itemArray.append(textField.text! )
               
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
       
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}

