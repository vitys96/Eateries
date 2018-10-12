import UIKit
import CoreData

class EateriesTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var fetchResultController: NSFetchedResultsController<Restaurant>!
    var searchController: UISearchController!
    var filterResultArray: [Restaurant] = []
    var restaurants: [Restaurant] = []
    @IBAction func close(segue: UIStoryboardSegue)
    {
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        configNavigationController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let userDefaults = UserDefaults.standard
        let wasWatched = userDefaults.bool(forKey: "wasWatched")
        guard !wasWatched else { return }
        if let pageVC = storyboard?.instantiateViewController(withIdentifier: "pageViewController") as? PageViewController
        {
            present(pageVC, animated: true, completion: nil)
        }
    }
    
    
    func filterContentFor(searchText text: String)
    {
        filterResultArray = restaurants.filter{ (restaurant) -> Bool in
            return (restaurant.name?.lowercased().contains(text.lowercased()))!
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createSearchController()
        
        
        tableView.backgroundColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
        definesPresentationContext = true
        
        let attributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .largeTitle), NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.largeTitleTextAttributes = attributes
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        tableView.estimatedRowHeight = 85
        
        tableView.rowHeight = UITableView.automaticDimension
        
        let fetchRequest: NSFetchRequest<Restaurant> = Restaurant.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext
        {
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            do {
                try fetchResultController.performFetch()
                restaurants = fetchResultController.fetchedObjects!
            }
            catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert: guard let indexPath = newIndexPath else { break }
        tableView.insertRows(at: [indexPath], with: .fade)
        case .delete: guard let indexPath = indexPath else { break }
        tableView.deleteRows(at: [indexPath], with: .fade)
        case .update: guard let indexPath = indexPath else { break }
        tableView.reloadRows(at: [indexPath], with: .fade)
        default:
            tableView.reloadData()
        }
        
        restaurants = controller.fetchedObjects as! [Restaurant]
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    
    func configNavigationController() {
        navigationController?.hidesBarsOnSwipe = false
        navigationItem.hidesSearchBarWhenScrolling = true
        navigationItem.searchController?.searchBar.keyboardAppearance = .dark
        navigationItem.searchController?.searchBar.tintColor = .black
        
        navigationController?.navigationBar.prefersLargeTitles = true
//        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func createSearchController() {
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        //searchController.searchBar.backgroundColor = .clear

        searchController.searchBar.resignFirstResponder()
        navigationItem.searchController = searchController
//        tableView.tableHeaderView = searchController.searchBar
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchController.searchBar.endEditing(true)
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filterResultArray.count
        }
        return restaurants.count
    }
    
    func restaurantToDisplayAt(indexPath: IndexPath) -> Restaurant {
        let restaurant: Restaurant
        if searchController.isActive && searchController.searchBar.text != "" {
            restaurant = filterResultArray[indexPath.row]
        }
        else {
            restaurant = restaurants[indexPath.row]
        }
        return restaurant
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! EateriesTableViewCell

        cell.backgroundColor = UIColor(hue: 0.1333, saturation: 0.3, brightness: 1, alpha: 1.0)
        cell.layer.borderColor = UIColor(hue: 0.6056, saturation: 0.26, brightness: 0.53, alpha: 1.0).cgColor
//
//        cell.layer.borderWidth = 0.3
//        cell.layer.cornerRadius = 2
        cell.clipsToBounds = true
        
        let restaraunt = restaurantToDisplayAt(indexPath: indexPath)
        
        cell.thumbnailImageView.image = UIImage(data: restaraunt.image! as Data)
        cell.thumbnailImageView.layer.cornerRadius = 37.5
        cell.thumbnailImageView.clipsToBounds = true
        cell.nameLabel.text = restaraunt.name
        cell.locationLabel.text = restaraunt.location
        cell.typeLabel.text = restaraunt.type
        cell.checkImage.isHidden = restaurants[indexPath.row].isVisited ? false: true
    
        return cell
    }

    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
 
        let delete =  UIContextualAction(style: .normal, title: "Удалить") { (action, view, completionHandler ) in
            self.restaurants.remove(at: indexPath.row)
            //            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            completionHandler(true)
            
            guard let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext else { return }
            let objectToDelete = self.fetchResultController.object(at: indexPath)
            context.delete(objectToDelete)
            
            do {
                try context.save()
            }
            catch {
                print (error.localizedDescription)
            }
        }
        
        
        let title = "Поделиться"
        let share =  UIContextualAction(style: .normal, title: title) { (action, view, completionHandler ) in
            let defaultText = "Взгляни на это заведение " + "\u{1F37D} \n" +
                "«\(self.restaurants[indexPath.row].name!)»" +
            ""
            if let image  = UIImage(data: self.restaurants[indexPath.row].image! as Data) {
                let activityController = UIActivityViewController(activityItems: [defaultText, image], applicationActivities: nil)
                self.present(activityController, animated: true, completion: nil)
            }
            completionHandler(true)

            
        }
        share.image = UIImage(named: "share")
        share.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        
        delete.image = UIImage(named: "delete")
        delete.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 0.8942904538)
        let confrigation = UISwipeActionsConfiguration(actions: [delete, share])
        return confrigation
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue"
        {
            if let indexPath = tableView.indexPathForSelectedRow
            {
                let dvc = segue.destination as? TableViewController
                dvc?.restaurant = restaurantToDisplayAt(indexPath: indexPath)
            }
        }
    }
}



// MARK: - EXTENSIONS

extension EateriesTableViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        filterContentFor(searchText: searchController.searchBar.text!)
        tableView.reloadData()
    }
}

extension UITableViewController {
    func gradientWithFrametoImage(frame: CGRect, colors: [CGColor]) -> UIImage? {
        let gradient: CAGradientLayer  = CAGradientLayer(layer: self.view.layer)
        gradient.frame = frame
        gradient.colors = colors
        UIGraphicsBeginImageContext(frame.size)
        gradient.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

extension EateriesTableViewController: UISearchBarDelegate
{
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        if searchBar.text == "" {
            navigationController?.hidesBarsOnSwipe = false
        }
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        navigationController?.hidesBarsOnSwipe = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchController.searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
}








