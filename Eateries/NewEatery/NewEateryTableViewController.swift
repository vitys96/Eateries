

import UIKit

class NewEateryTableViewController: UITableViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate {
    
    var star: Double!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet var starOutletCollection: [UIButton]!
    
    @IBAction func starButtonAction(_ sender: UIButton) {

        switch sender.tag {
        case 0:
            star = 1
            for i in 0...4 {
                if i == 0 {
                    starOutletCollection[i].setImage(UIImage(named: "star1"), for: .normal)
                }
                else {
                    starOutletCollection[i].setImage(UIImage(named: "star"), for: .normal)
                }

            }
            hideKeyboard()

        case 1:
            star = 2
            for i in 0...sender.tag {
                if i == 1 {
                    for i in 0...1 {
                        starOutletCollection[i].setImage(UIImage(named: "star1"), for: .normal)
                    }
                    for i in 2...4 {
                        starOutletCollection[i].setImage(UIImage(named: "star"), for: .normal)
                    }
                }
            }
            hideKeyboard()
        case 2:
            for i in 0...sender.tag {
                if i == 2 {
                    for i in 0...2 {
                        starOutletCollection[i].setImage(UIImage(named: "star1"), for: .normal)
                    }
                }
                for i in 3...4 {
                    starOutletCollection[i].setImage(UIImage(named: "star"), for: .normal)
                }
                star = 3
            }
            hideKeyboard()
        case 3:
            for i in 0...sender.tag {
                if i == 3 {
                    for i in 0...3 {
                        starOutletCollection[i].setImage(UIImage(named: "star1"), for: .normal)
                    }
                }
                for i in 4...4 {
                    starOutletCollection[i].setImage(UIImage(named: "star"), for: .normal)
                }
                star = 4
            }
            hideKeyboard()
        case 4:
            for i in 0...sender.tag {
                if i == 4 {
                    for i in 0...4 {
                        starOutletCollection[i].setImage(UIImage(named: "star1"), for: .normal)
                    }
                }
                else {
                    starOutletCollection[i].setImage(UIImage(named: "star"), for: .normal)
                }
                star = 5
            }
            hideKeyboard()
        default:
            break
        }
    }
    
    
    @IBAction func saveButton(_ sender: UIBarButtonItem)
    {
        if nameTextField.text == "" || addressTextField.text == "" || typeTextField.text == "" {
            let alertController = UIAlertController(title: "Ошибка!", message: "Не все поля были заполнены!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
        else
        {
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext
            {
                let restaurant = Restaurant(context: context)
                restaurant.name = nameTextField.text?.capitalized
                restaurant.location = addressTextField.text?.capitalized
                restaurant.type = typeTextField.text?.capitalized
                restaurant.isVisited = isVisited
                restaurant.star = star
                restaurant.isFavourite = false
                if let image = imageView.image {
                    restaurant.image = image.pngData()
                }
                
                do {
                    try context.save()
                }
                catch let error as NSError
                {
                    print ("Не удалось сохранить данные \(error.localizedDescription)")
                }
            }
            performSegue(withIdentifier: "unwind", sender: self)
        }
    }
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var yesButtonOutlet: UIButton!
    @IBOutlet weak var noButtonOutlet: UIButton!
    
    var isVisited = false
    
    @IBAction func toggleIsVisited(_ sender: UIButton)
    {
        if sender == yesButtonOutlet
        {
            sender.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
            noButtonOutlet.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            isVisited = true
            hideKeyboard()
            let alert = UIAlertController(title: "Средний чек\u{1F4B0}", message: "Впишите среднюю сумму чека", preferredStyle: UIAlertController.Style.alert)
            
            let cancelAction = UIAlertAction(title: "Отмена", style: .default, handler: { (action: UIAlertAction!) in })
            
            let saveAction = UIAlertAction(title: "ОК", style: .default, handler: { (action: UIAlertAction!) in
                ////
            })
            
            alert.addTextField(configurationHandler: { textField in
                textField.keyboardType = .numberPad
                textField.keyboardAppearance = .dark
                textField.autocorrectionType = .default
                textField.placeholder = "Руб."
                textField.clearButtonMode = .whileEditing

            })
            
//            alert.addTextField { (textField: UITextField!) in
//                textField.keyboardType = .numberPad
//            }
            
            alert.addAction(cancelAction)
            alert.addAction(saveAction)
            
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            sender.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            yesButtonOutlet.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            isVisited = false
            hideKeyboard()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        addressTextField.delegate = self
        typeTextField.delegate = self
        
        yesButtonOutlet.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        yesButtonOutlet.layer.cornerRadius = 10
        noButtonOutlet.layer.cornerRadius = 10
        noButtonOutlet.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard()
        return true
    }

    
    func hideKeyboard() {
        nameTextField.resignFirstResponder()
        addressTextField.resignFirstResponder()
        typeTextField.resignFirstResponder()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        imageView.image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0
        {
            let alertContrl = UIAlertController(title: "Источник фотографии", message: nil, preferredStyle: .actionSheet)
            
            let cameraAction = UIAlertAction(title: "Камера", style: .default) { (action) in
                self.choouseImagePickerActiom(source: .camera)
            }
            let photoLibrary = UIAlertAction(title: "Фото", style: .default) { (action) in
                self.choouseImagePickerActiom(source: .photoLibrary)
            }
            let cancel = UIAlertAction(title: "Отмена", style: .default, handler: nil)
            
            alertContrl.addAction(cameraAction)
            alertContrl.addAction(photoLibrary)
            alertContrl.addAction(cancel)
            
            self.present(alertContrl, animated: true, completion: nil)
            
            tableView.deselectRow(at: indexPath, animated: false)
        }
        
    }
    
    func choouseImagePickerActiom(source: UIImagePickerController.SourceType)
    {
        if UIImagePickerController.isSourceTypeAvailable(source)
        {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    
}





// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}
