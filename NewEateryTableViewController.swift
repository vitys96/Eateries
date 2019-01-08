import UIKit
import Cosmos

class NewEateryTableViewController: UITableViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var starsRating: CosmosView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    
    @IBOutlet weak var yesButtonOutlet: UIButton!
    @IBOutlet weak var noButtonOutlet: UIButton!
    @IBOutlet weak var averagePrice: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    var restaraunt: Restaurant?
    

    
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        if nameTextField.text == "" || addressTextField.text == "" || typeTextField.text == ""  {
            let alertController = UIAlertController(title: "Ошибка!", message: "Не все поля были заполнены!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
        else {
            guard let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext else { return }
            
            if restaraunt != nil {
                context.delete(restaraunt!)
            }
            let restaurant = Restaurant(context: context)
            restaurant.name = nameTextField.text?.capitalized
            restaurant.location = addressTextField.text?.capitalized
            restaurant.type = typeTextField.text?.capitalized
            restaurant.isVisited = isVisited
            restaurant.isFavourite = false
            restaurant.averageCheck = averageMoney
            if imageView.image == nil {
                restaurant.isPhoto = false
                
                let nama = UIImage(named: "noPhoto")
                guard let image = nama else { return }
                restaurant.image = image.pngData()
            } else {
                restaurant.isPhoto = true
                if let image = imageView.image {
                    restaurant.image = image.pngData()
                }
            }
            restaurant.star = starsRating.rating
            
            do {
                try context.save()
            }
            catch let error as NSError{
                print ("Не удалось сохранить данные \(error.localizedDescription)")
            }
            let defaults = UserDefaults.standard
            defaults.set(false, forKey: "modernRests")
            performSegue(withIdentifier: "unwind", sender: self)
        }
    }
    
    @IBAction func toggleIsVisited(_ sender: UIButton) {
        if sender == yesButtonOutlet {
            noButtonOutlet.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            isVisited = true
            
            let alert = UIAlertController(title: "Средний чек\u{1F4B0}", message: "Впишите среднюю сумму чека", preferredStyle: UIAlertController.Style.alert)
            
            let cancelAction = UIAlertAction(title: "Отмена", style: .default, handler: { (action: UIAlertAction!) in    
            })
            
            let saveAction = UIAlertAction(title: "ОК", style: .default) { (action) in
                guard let textField = alert.textFields?.first else { return }
                if textField.text != "" {
                    sender.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
                    self.averagePrice.isHidden = false
                    self.priceLabel.isHidden = false
                    self.priceLabel.text = textField.text! + " ₽"
                    self.averageMoney = textField.text
                }
                else {
                    self.averagePrice.isHidden = true
                    self.priceLabel.isHidden = true
                }
                
            }
            alert.addTextField(configurationHandler: { textField in
                textField.keyboardType = .numberPad
                textField.keyboardAppearance = .dark
                textField.autocorrectionType = .default
                textField.placeholder = "Руб."
                textField.clearButtonMode = .whileEditing
                
            })
            
            alert.addAction(cancelAction)
            alert.addAction(saveAction)
            
            self.present(alert, animated: true, completion: nil)
        }
        else {
            sender.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            yesButtonOutlet.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            isVisited = false
            self.averagePrice.isHidden = true
            self.priceLabel.isHidden = true
            self.priceLabel.text = ""
        }
    }
    
    var isVisited = false
    var averageMoney: String!
    var star: Double = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startScreenConfig()
        
        
        starsRating.didTouchCosmos = { rating in
            self.star = rating
        }
        
        guard let restaraunt = restaraunt else { return }
        nameTextField.text = restaraunt.name
        addressTextField.text = restaraunt.location
        typeTextField.text = restaraunt.type
        
        if restaraunt.isPhoto == false {
            imageView.contentMode = .scaleAspectFill
        }
        
        let image = UIImage(data: self.restaraunt!.image! as Data)
        imageView.image = image
        starsRating.rating = restaraunt.star
        
        
        
    }
    
    
    
    
    func startScreenConfig() {
        averagePrice.isHidden = true
        priceLabel.isHidden = true
        
        nameTextField.delegate = self
        addressTextField.delegate = self
        typeTextField.delegate = self
        
        yesButtonOutlet.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        yesButtonOutlet.layer.cornerRadius = 10
        noButtonOutlet.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        noButtonOutlet.layer.cornerRadius = 10
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        addressTextField.resignFirstResponder()
        typeTextField.resignFirstResponder()
        return true
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
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
        if UIImagePickerController.isSourceTypeAvailable(source) {
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

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}
