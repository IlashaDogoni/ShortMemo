//
//  ToDoViewController.swift
//  ShortMemo
//
//  Created by Ilya Kokorin on 26.03.2022.
//

import UIKit
import CoreData

class ToDoViewController: UIViewController {

    
    @IBOutlet var searchBar: UISearchBar!
 
    @IBOutlet var tableView: UITableView!
    var itemArray = [Item]()
    var selectedCategory : Category?{
        didSet{
            loadItems()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        tableView.register(UINib(nibName: K.itemCellNIBname, bundle: nil), forCellReuseIdentifier: K.itemCellIdentifier)
        navigationItem.title = selectedCategory?.name
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Добавьте новый элемент", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Добавить", style: .default) { action in
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            self.saveItems()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Название элемента"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Stuff to do with items
    func saveItems(){
        do{
            try context.save()
        } catch {
            print("Error \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){
        let categoryPredicate = NSPredicate(format: K.predicateMatches, selectedCategory!.name!)
        
        if let additionalPredicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do{
            itemArray =  try context.fetch(request)
        } catch {
            print("Error \(error)")
        }
        tableView?.reloadData()
    }
}

extension ToDoViewController : UITableViewDelegate{
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
    }
}

extension ToDoViewController : UITableViewDataSource{
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.itemCellIdentifier, for: indexPath) as! ItemCell
        let item = itemArray[indexPath.row]
        cell.label.text = item.title
        cell.checkmarkImageView.alpha = item.done ? 1 : 0
        return cell
    }
    
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            context.delete(itemArray[indexPath.row])
            itemArray.remove(at: indexPath.row)
            saveItems()
        }
}
}
    
extension ToDoViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: K.predicateContains, searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: K.descriptorKey, ascending: true)]
        loadItems(with: request, predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}
