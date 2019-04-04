import UIKit
import CoreData

class EateriesTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var fetchResultController: NSFetchedResultsController<Restaurant>!
    var searchController: UISearchController!
    var filterResultArray: [Restaurant] = []
    var restaurants: [Restaurant] = []
    
    override func viewWillAppear(_ animated: Bool) {
        performFetchData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let userDefaults = UserDefaults.standard
        let wasWatched = userDefaults.bool(forKey: "wasWatched")
        guard !wasWatched else { return }
        if let pageVC = storyboard?.instantiateViewController(withIdentifier: "pageViewController") as? PageViewController {
            present(pageVC, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configNavigationController()
        configureStartScreen()
        createSearchController()
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
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchController.searchBar.endEditing(true)
    }
    
    func filterContentFor(searchText text: String)
    {
        filterResultArray = restaurants.filter{ (restaurant) -> Bool in
            return (restaurant.name?.lowercased().contains(text.lowercased()))!
        }
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
    
    
    // MARK: - MY FUNCTIONS
    
    private func configNavigationController() {
        navigationController?.hidesBarsOnSwipe = false
        navigationItem.hidesSearchBarWhenScrolling = true
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController?.searchBar.keyboardAppearance = .dark
    }
    
    
    private func createSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.resignFirstResponder()
        navigationItem.searchController = searchController
        searchController.searchBar.setSearchFieldBackgroundImage(UIImage(named: "search_Baar"), for: UIControl.State.normal)
    }
    
    private func configureStartScreen() {
        tableView.backgroundColor = UIColor(hue: 0.1333, saturation: 0.3, brightness: 1, alpha: 1.0)
        definesPresentationContext = true
        
        let attributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .largeTitle), NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.largeTitleTextAttributes = attributes
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        tableView.estimatedRowHeight = 85
        
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func performFetchData() {
        
        let fetchRequest: NSFetchRequest<Restaurant> = Restaurant.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext {
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            
            do {
                try fetchResultController.performFetch()
                guard let fetchObjects = fetchResultController.fetchedObjects else { return }
                restaurants = fetchObjects
                
                if fetchResultController.fetchedObjects?.count == 0 && !UserDefaults.standard.bool(forKey: "rest") {
                    insertModernRests()
                }
            } catch { }
        }
    }
}

// MARK: - EXTENSIONS

extension EateriesTableViewController {
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filterResultArray.count
        }
        return restaurants.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! EateriesTableViewCell
        
        cell.backgroundColor = UIColor(hue: 0.1333, saturation: 0.3, brightness: 1, alpha: 1.0)
        cell.layer.borderColor = UIColor(hue: 0.6056, saturation: 0.26, brightness: 0.53, alpha: 1.0).cgColor
        
        cell.clipsToBounds = true
        
        let restaraunt = restaurantToDisplayAt(indexPath: indexPath)
        
        cell.thumbnailImageView.image = UIImage(data: restaraunt.image! as Data)
        cell.thumbnailImageView.layer.cornerRadius = 37.5
        cell.thumbnailImageView.clipsToBounds = true
        cell.nameLabel.text = restaraunt.name
        cell.locationLabel.text = restaraunt.location
        cell.typeLabel.text = restaraunt.type
        cell.checkImage.isHidden = restaurants[indexPath.row].isVisited ? false : true
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if !self.searchController.isActive {
            let delete =  UIContextualAction(style: .normal, title: nil) { (_, _, completionHandler ) in
                
                self.restaurants.remove(at: indexPath.row)
                //                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                completionHandler(true)
                
                guard let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext else { return }
                let objectToDelete = self.fetchResultController.object(at: indexPath)
                context.delete(objectToDelete)
                do {
                    try context.save()
                } catch {
                    
                }
            }
            let shareText = shareRests(firstTitle: beginningText, secTitle: adressText, nameRest: (String(describing: self.restaurants[indexPath.row].name!)), addressRest: (String(describing:self.restaurants[indexPath.row].location!)), link: linkOfRests)
            
            let share =  UIContextualAction(style: .normal, title: nil) { (_, _, completionHandler ) in
                guard let image  = UIImage(data: self.restaurants[indexPath.row].image! as Data) else { return }
                let activityController = UIActivityViewController(activityItems: [shareText, image], applicationActivities: nil)
                self.present(activityController, animated: true)
                
                completionHandler(true)
            }
            
            share.image = UIImage(named: "share1")
            share.backgroundColor = UIColor(red:0.67, green:0.67, blue:0.67, alpha:1.0)
            
            delete.image = UIImage(named: "delete")
            delete.backgroundColor =  UIColor(red:0.85, green:0.31, blue:0.11, alpha:1.0)
            let confrigation = UISwipeActionsConfiguration(actions: [delete, share])
            return confrigation
        }
        else {
            return UISwipeActionsConfiguration(actions: [])
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let dvc = segue.destination as? TableViewController
                dvc?.restaurant = restaurantToDisplayAt(indexPath: indexPath)
            }
        }
    }
    
    private func insertModernRests() {
        var modernImages = [UIImage(named: "rest1"), UIImage(named: "rest2"), UIImage(named: "rest3")]
        ModernRests.addModernRests(name: "One Teaspoon", location: "Яузский б-р, 14/8", type: "Ресторан", isVisited: false, isFavourite: false, averageCheck: nil, image: modernImages[0]!, isPhoto: true, star: 5)
        ModernRests.addModernRests(name: "Шоколадница", location: "Автозаводская, 9/1", type: "Кофейня", isVisited: false, isFavourite: false, averageCheck: nil, image: modernImages[1]!, isPhoto: true, star: 5)
        ModernRests.addModernRests(name: "Грабли", location: "Солянка, 1/2", type: "Ресторан", isVisited: false, isFavourite: false, averageCheck: nil, image: modernImages[2]!, isPhoto: true, star: 5)
        
        UserDefaults.standard.set(true, forKey: "rest")
    }
}

extension EateriesTableViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentFor(searchText: searchController.searchBar.text!)
        tableView.reloadData()
    }
}

extension EateriesTableViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if searchBar.text == "" {
            navigationController?.hidesBarsOnSwipe = false
        }
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        navigationController?.hidesBarsOnSwipe = false
    }
}
