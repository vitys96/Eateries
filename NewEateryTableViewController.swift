import UIKit
import Cosmos
import RAMPaperSwitch

class NewEateryTableViewController: UITableViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var starsRating: CosmosView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    
    @IBOutlet weak var yesButtonOutlet: UIButton!
    @IBOutlet weak var noButtonOutlet: UIButton!
    @IBOutlet weak var averagePrice: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var contentViewOfSwitcher: UIView!
    
    @IBOutlet weak var `switch`: RAMPaperSwitch!
    
    
    var restaraunt: Restaurant?
    
    var isVisited : Bool!
    var averageMoney: String!

    var isFavourite: Bool!
    
    @IBAction func cancelBtn(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        if nameTextField.text == "" || addressTextField.text == "" || typeTextField.text == ""  {
            let alertController = UIAlertController(title: "Ошибка!", message: "Не все поля были заполнены!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)

        }
        else {
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext {
                
                if restaraunt != nil {
                    context.delete(restaraunt!)
                }
                let restaurant = Restaurant(context: context)
                restaurant.name = nameTextField.text?.capitalized
                restaurant.location = addressTextField.text?.capitalized
                restaurant.type = typeTextField.text?.capitalized
                restaurant.averageCheck = averageMoney
                
                if isFavourite == nil || isFavourite == false {
                restaurant.isFavourite = false
                }
                else {
                    restaurant.isFavourite = true
                }
                
                if isVisited == nil {
                    restaurant.isVisited = false
                }
                else {
                    restaurant.isVisited = isVisited
                }
                
                if imageView.image == nil {
                    restaurant.isPhoto = false
                    let noImage = UIImage(named: "noPhoto")
                    guard let image = noImage else { return }
                    restaurant.image = image.pngData()
                    
                } else {
                    restaurant.isPhoto = true
                    if let image = imageView.image {
                        restaurant.image = image.pngData()
                        
                    }
                }
                //                imageView.contentMode = .scaleAspectFit
                restaurant.star = starsRating.rating
                
                do {
                    try context.save()
                    navigationController?.popToRootViewController(animated: true)
                    dismiss(animated: true, completion: nil)
                }
                    
                catch { }
                
                
            }
            
//            for controller in self.navigationController!.viewControllers as Array {
//                if controller.isKind(of: EateriesTableViewController.self) {
//                    self.navigationController!.popToViewController(controller, animated: true)
//
//                }
//            }
        }

        
    }
    
    
//    @IBAction func toggleIsVisited(_ sender: UIButton) {
//        if sender == yesButtonOutlet {
//            noButtonOutlet.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
//
//            let alert = UIAlertController(title: "Средний чек\u{1F4B0}", message: "Впишите среднюю сумму чека", preferredStyle: UIAlertController.Style.alert)
//
//            let cancelAction = UIAlertAction(title: "Отмена", style: .default, handler: { (action: UIAlertAction!) in
//            })
//
//            let saveAction = UIAlertAction(title: "ОК", style: .default) { (action) in
//                guard let textField = alert.textFields?.first else { return }
//                //                if textField.text != "" {
//                sender.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
//                self.averagePrice.isHidden = false
//                self.priceLabel.isHidden = false
//                self.priceLabel.text = textField.text! + " ₽"
//                self.averageMoney = textField.text
//                self.isVisited = true
//
//            }
//
//            alert.addTextField(configurationHandler: { textField in
//                saveAction.isEnabled = false
//                textField.keyboardType = .numberPad
//                textField.keyboardAppearance = .dark
//                textField.autocorrectionType = .default
//                textField.placeholder = "Руб."
//                textField.clearButtonMode = .whileEditing
//
//                textField.addTarget(self, action: #selector(self.alertTextFieldDidChange(field:)), for: .editingChanged)
//            })
//
//            alert.addAction(cancelAction)
//            alert.addAction(saveAction)
//
//            self.present(alert, animated: true, completion: nil)
//        }
//        else {
//            sender.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
//            yesButtonOutlet.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
//            isVisited = false
//            self.averagePrice.isHidden = true
//            self.priceLabel.isHidden = true
//            self.priceLabel.text = ""
//        }
//    }
    
    //    override func viewWillAppear(_ animated: Bool) {
    //        super.viewWillAppear(animated)
    //        saveBtnOutlet.isEnabled = false
    //    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startScreenConfig()
        
        self.hideKeyboardWhenTappedAround()
        
        self.switch.animationDidStartClosure = {(onAnimation: Bool) in
            UIView.transition(with: self.contentViewOfSwitcher, duration: self.switch.duration, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {
                if onAnimation {
                    if self.isVisited == nil || self.isVisited == false {
                        let alert = UIAlertController(title: "Средний чек\u{1F4B0}", message: "Впишите среднюю сумму чека", preferredStyle: UIAlertController.Style.alert)
                        
                        let cancelAction = UIAlertAction(title: "Отмена", style: .default, handler: { (action: UIAlertAction!) in
                            self.switch.setOn(false, animated: true)
                            self.averagePrice.isHidden = true
                            self.priceLabel.isHidden = true
                            self.isVisited = false
                        })
                        
                        let saveAction = UIAlertAction(title: "ОК", style: .default) { (action) in
                            guard let textField = alert.textFields?.first else { return }
                            
                            self.priceLabel.fadeOut(0.2, delay: 0.0, completion: { (finish) in
                                self.averagePrice.isHidden = false
                                self.priceLabel.isHidden = false
                                self.priceLabel.text = textField.text! + " ₽"
                                self.averageMoney = textField.text
                                self.priceLabel.fadeIn()
                                self.isVisited = true
                            })
                            
                            
                        }
                        alert.addTextField(configurationHandler: { textField in
                            saveAction.isEnabled = false
                            textField.keyboardType = .numberPad
                            textField.keyboardAppearance = .dark
                            textField.autocorrectionType = .default
                            textField.placeholder = "Руб."
                            textField.clearButtonMode = .whileEditing
                            
                            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: OperationQueue.main) { (notification) in
                                saveAction.isEnabled = textField.text!.count > 0
                            }
                        })
                        
                        alert.addAction(cancelAction)
                        alert.addAction(saveAction)
                        
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                }
                else if !onAnimation {
                    self.averagePrice.isHidden = true
                    self.priceLabel.isHidden = true
                    self.isVisited = false
                }

            }, completion: nil)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if restaraunt?.isVisited == true {
            
            self.switch.setOn(true, animated: true)
            self.averagePrice.isHidden = false
            self.priceLabel.isHidden = false
            self.priceLabel.text = (restaraunt?.averageCheck)! + " ₽"
        }
    }
    
    func startScreenConfig() {
        averagePrice.isHidden = true
        priceLabel.isHidden = true
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        nameTextField.delegate = self
        addressTextField.delegate = self
        typeTextField.delegate = self
        
        
        guard let restaraunt = restaraunt else { return }
        nameTextField.text = restaraunt.name
        addressTextField.text = restaraunt.location
        typeTextField.text = restaraunt.type
        
        
        let image = UIImage(data: self.restaraunt!.image! as Data)
        imageView.image = image
        starsRating.rating = restaraunt.star
        
        if restaraunt.isPhoto == false {
            imageView.contentMode = .scaleAspectFit
        }
        
        self.isFavourite = restaraunt.isFavourite
        self.isVisited = restaraunt.isVisited
        self.averageMoney = restaraunt.averageCheck
        
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



extension NewEateryTableViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameTextField:
            addressTextField.becomeFirstResponder()
        case addressTextField:
            typeTextField.becomeFirstResponder()
        case typeTextField:
            typeTextField.resignFirstResponder()
        default:
            break
        }
        return false
    }
    
//    @objc func alertTextFieldDidChange(field: UITextField) {
//        let alertController: UIAlertController = self.presentedViewController as! UIAlertController
//        let textField: UITextField  = alertController.textFields![0]
//        let addAction: UIAlertAction = alertController.actions[1]
//        
//        guard let text = textField.text else { return }
//        
//        if !text.isEmpty {
//            addAction.isEnabled = true
//        }
//    }
}
