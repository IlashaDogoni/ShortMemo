//
//  CategoryViewController.swift
//  ShortMemo
//
//  Created by Ilya Kokorin on 21.03.2022.

import UIKit
import CoreData

class CategoryViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var navigationBar: UINavigationItem!
    override func viewDidLoad() {
        tableView.dataSource = self
        tableView.delegate = self
        // navigationController?.navigationBar.prefersLargeTitles = true
        //  navigationController?.navigationBar.barTintColor = UIColor(red: 40, green: 51, blue: 74, alpha: 1)
        super.viewDidLoad()
        tableView.register(UINib(nibName: K.categoryCellNIBname, bundle: nil), forCellReuseIdentifier: K.categoryCellIdentifier)
        navigationItem.title = K.categoryVCtitle
        loadCategories()
        if categoryArray.first == nil{
            let newCategory = Category(context: self.context)
            newCategory.name = "Тест"
            categoryArray.append(newCategory)
            saveCategories()
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Добавьте новую категорию", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Добавить", style: .default) { action in
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            self.categoryArray.append(newCategory)
            self.saveCategories()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Название категории"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveCategories(){
        do{
            try context.save()
        } catch {
            print("Error \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()){
        do{
            categoryArray =  try context.fetch(request)
        } catch {
            print("Error \(error)")
        }
        tableView.reloadData()
    }
}

extension CategoryViewController: UITableViewDelegate{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.seguePopover {
            let controller = segue.destination as! PopoverViewController
            controller.modalPresentationStyle = UIModalPresentationStyle.popover
            controller.popoverPresentationController!.delegate = self
        } else{
            let destinationVC = segue.destination as! ToDoViewController
            if let indexPath = tableView.indexPathForSelectedRow{
                destinationVC.selectedCategory = categoryArray[indexPath.row]
            }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.segueGoToItems, sender: self)
    }
}

extension CategoryViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.categoryCellIdentifier, for: indexPath) as! CategoryCell
        cell.label.text = categoryArray[indexPath.row].name
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            context.delete(categoryArray[indexPath.row])
            categoryArray.remove(at: indexPath.row)
            saveCategories()
        }
    }
}
