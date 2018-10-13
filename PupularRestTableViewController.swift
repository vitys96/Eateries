import UIKit
import CoreData


class PupularRestTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var fetchResultController: NSFetchedResultsController<Restaurant>!
    var restaurants: [Restaurant] = []
    var count = 0
    public var popularRests: [Restaurant] = []
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        let fetchRequest: NSFetchRequest<Restaurant> = Restaurant.fetchRequest()
       
        fetchRequest.predicate = NSPredicate(format: "isFavourite == %d", 1)
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext {
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            do {
                try fetchResultController.performFetch()
                popularRests = fetchResultController.fetchedObjects!
            }
            catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configNavigationController()
        
        tableView.backgroundColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
        definesPresentationContext = true
        
        let attributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .largeTitle), NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.largeTitleTextAttributes = attributes
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        // setup
        tableView.estimatedRowHeight = 85
        tableView.rowHeight = UITableView.automaticDimension
    }
    
//    func setup
    func configNavigationController() {
        navigationController?.hidesBarsOnSwipe = false
        navigationItem.hidesSearchBarWhenScrolling = true
        navigationItem.searchController?.searchBar.keyboardAppearance = .dark
        navigationItem.searchController?.searchBar.tintColor = .black
        
        navigationController?.navigationBar.prefersLargeTitles = true
        //        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return popularRests.count
    }
    
    //    func restaurantToDisplayAt(indexPath: IndexPath) -> Restaurant {
    //        let restaurant: Restaurant
    //        if restaurants[indexPath.row].isFavourite {
    //            restaurant = popularRests[indexPath.row]
    //        }
    //        else {
    //            restaurant = restaurants[indexPath.row]
    //        }
    //        return restaurant
    //    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PopularRestTableViewCell
        
        cell.backgroundColor = UIColor(hue: 0.1333, saturation: 0.3, brightness: 1, alpha: 1.0)
        cell.layer.borderColor = UIColor(hue: 0.6056, saturation: 0.26, brightness: 0.53, alpha: 1.0).cgColor
        //        cell.layer.borderWidth = 0.3
        //        cell.layer.cornerRadius = 2
        cell.clipsToBounds = true
        
//                let restaurant = restaurantToDisplayAt(indexPath: indexPath)
        let restaurant = popularRests[indexPath.row]
        
        cell.imageViewPopular.image = UIImage(data: restaurant.image! as Data)
        cell.imageViewPopular.layer.cornerRadius = 37.5
        cell.imageViewPopular.clipsToBounds = true
        cell.nameLabelPopular.text = restaurant.name
        cell.locationLabelPopular.text = restaurant.location
//        cell.tyoeLabelPopular.text = restaurant.type
//        cell.checkImageViewPopular.isHidden = restaurants[indexPath.row].isVisited ? false: true
        return cell
    }
    
}
