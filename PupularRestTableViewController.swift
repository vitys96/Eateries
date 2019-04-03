import UIKit
import CoreData


class PupularRestTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var fetchResultController: NSFetchedResultsController<Restaurant>!

    var popularRests: [Restaurant] = []

    
    let heartImage = UIImageView()
    let headerOfLabel = UILabel()
    let tinyText = UILabel()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configNavigationController()
        
        tableView.backgroundColor = UIColor(hue: 0.1333, saturation: 0.3, brightness: 1, alpha: 1.0)
        definesPresentationContext = true
        
        let attributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .largeTitle), NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.largeTitleTextAttributes = attributes
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        tableView.estimatedRowHeight = 85
        tableView.rowHeight = UITableView.automaticDimension
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        
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
                if fetchResultController.fetchedObjects?.count == 0 && popularRests.count == 0 {
                    emptyPopRestLables()
                }
                else {
                    hideDescribingText()
                }
            }
            catch { }
        }
        tableView.reloadSections(IndexSet(integer: 0), with: .none)
    }

    func configNavigationController() {
        navigationController?.hidesBarsOnSwipe = false
        navigationItem.hidesSearchBarWhenScrolling = true
        navigationItem.searchController?.searchBar.keyboardAppearance = .dark
        navigationItem.searchController?.searchBar.tintColor = .black
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return popularRests.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PopularRestTableViewCell
        
        cell.backgroundColor = UIColor(hue: 0.1333, saturation: 0.3, brightness: 1, alpha: 1.0)
        cell.layer.borderColor = UIColor(hue: 0.6056, saturation: 0.26, brightness: 0.53, alpha: 1.0).cgColor
        cell.clipsToBounds = true
        
        let restaurant = popularRests[indexPath.row]
        
        cell.imageViewPopular.image = UIImage(data: restaurant.image! as Data)
        cell.imageViewPopular.layer.cornerRadius = 10
        cell.imageViewPopular.clipsToBounds = true
        cell.nameLabelPopular.text = restaurant.name
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "popularShow"
        {
            if let indexPath = tableView.indexPathForSelectedRow
            {
                let dvc = segue.destination as? TableViewController
                dvc?.restaurant = popularRests[indexPath.row]
            }
        }
    }
    
    private func emptyPopRestLables() {
        
        heartImage.image = UIImage(named: "emptyHeart")
        view.addSubview(heartImage)
        heartImage.translatesAutoresizingMaskIntoConstraints = false
        heartImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
        heartImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        heartImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        heartImage.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -150).isActive = true
        
        
        headerOfLabel.text = "Нет избранных заведений"
        headerOfLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        headerOfLabel.textColor = .gray
        
        view.addSubview(headerOfLabel)
        headerOfLabel.translatesAutoresizingMaskIntoConstraints = false
        headerOfLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        headerOfLabel.topAnchor.constraint(equalTo: heartImage.bottomAnchor, constant: 20).isActive = true
        headerOfLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
        tinyText.text = "Нажмите на значок сердца в карточке заведения, чтобы добавить его в избранное."
        tinyText.font = UIFont(name: "HelveticaNeue ", size: 14)
        tinyText.textColor = .gray
        tinyText.numberOfLines = 0
        tinyText.lineBreakMode = .byWordWrapping
        tinyText.textAlignment = .center
        
        view.addSubview(tinyText)
        tinyText.translatesAutoresizingMaskIntoConstraints = false
        tinyText.heightAnchor.constraint(equalToConstant: 70).isActive = true
        tinyText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        tinyText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 10).isActive = true
        tinyText.topAnchor.constraint(equalTo: headerOfLabel.bottomAnchor, constant: 0).isActive = true
        tinyText.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }
    
    private func hideDescribingText() {
        heartImage.removeFromSuperview()
        headerOfLabel.removeFromSuperview()
        tinyText.removeFromSuperview()
        
    }
    
}
