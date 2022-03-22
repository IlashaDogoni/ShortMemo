//
//  PopoverViewController.swift
//  ShortMemo
//
//  Created by Ilya Kokorin on 22.03.2022.
//

import UIKit

class PopoverViewController: UIViewController {
    
    let helpString = """
    Добавление категории/элемента - '+', удаление - свайп влево.\n
    Добавьте новую категорию.\n Нажмите на название категории и попадете в список элементов категории.\n
    Добавьте новые элементы в список.\n
    Доступен поиск элементов в списке - там разберетесь:)\n
    Нажатие на элемент помечает его галочкой, повторное нажатие - снимает галочку.
 """
    @IBOutlet var textLabel: UILabel!
    @IBOutlet var okButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        okButton.layer.cornerRadius = 5
        textLabel.text = helpString
    }
    
    @IBAction func okButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
