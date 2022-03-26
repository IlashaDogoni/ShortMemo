//
//  CategoryViewController.swift
//  ShortMemo
//
//  Created by Ilya Kokorin on 21.03.2022.
//
// Да, нужно было tableViews добавлять на обычный ViewController, тогда получился бы фон для ячеек таблицы, увы, просмотрел, сейчас времени уже нет:(
import UIKit
import CoreData

class CategoryViewController: UITableViewController, UIPopoverPresentationControllerDelegate {
    
    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet var navigationBar: UINavigationItem!
    override func viewDidLoad() {
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
    
    //MARK: - Table view datasource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.categoryCellIdentifier, for: indexPath) as! CategoryCell
        cell.label.text = categoryArray[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            context.delete(categoryArray[indexPath.row])
            categoryArray.remove(at: indexPath.row)
            saveCategories()
        }
    }
    //MARK: - Table view delegate methods
    
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
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.segueGoToItems, sender: self)
    }
    //MARK: - Stuff to do with categories
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


