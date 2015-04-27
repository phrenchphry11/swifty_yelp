//
//  BusinessesViewController.swift
//  Yelp
//
//  Copyright (c) 2015 Holly French. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, FiltersViewControllerDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    var businesses: [Business] = []
    
    var filtered: [Business] = []
    
    var filters: [String : NSObject] = [:]
    
    var business: Business?

    var searchActive: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Yelp"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Filter", style: .Plain, target: self, action: "onFilterButton")
        
        self.navigationController?.navigationBar.barTintColor = UIColor.redColor()
        
        self.fetchBusinessesWithQuery([], deals:0, distance:0, sort:0)
        
        // Table Search Results View
        self.searchBar.delegate = self
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.registerNib(UINib(nibName: "BusinessCell", bundle: nil), forCellReuseIdentifier: "BusinessCell")
        self.tableView.estimatedRowHeight = 50
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "filtersViewSegue") {
            var filtersViewController = segue.destinationViewController as! FiltersViewController
            filtersViewController.delegate = self
        }
        else if (segue.identifier == "businessViewSegue") {
            var businessViewController = segue.destinationViewController as! BusinessIndividualViewController
            
            businessViewController.business = self.business
        }
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (searchActive && filtered.count > 0) {
            return filtered.count
        } else {
            return businesses.count
        }
  
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("BusinessCell") as! BusinessCell
        
        
        var business = self.businesses[indexPath.row]
        
        if (searchActive && filtered.count > 0) {
            business = self.filtered[indexPath.row]
        }
        
        cell.setBusiness(business)
        return cell
    }
    
    func onFilterButton() {
        performSegueWithIdentifier("filtersViewSegue", sender: self)
    }
    
    func didChangeFilters(filtersViewController: FiltersViewController, filters: [String : NSObject]) {
        self.filters = filters
        var categories = filters["categories"] as! [String]
        var deals = filters["deals"] as! Int
        var distance = filters["distance"] as! Int
        var sort = filters["sort"] as! Int
        self.fetchBusinessesWithQuery(categories, deals:deals, distance:distance, sort:sort)
    }
    
    func didChangeBusiness(businessIndividualViewController: BusinessIndividualViewController, business: Business) {
        self.business = business
    }
    
    func fetchBusinessesWithQuery(categories: [String], deals: Int, distance: Int, sort: Int) {
        var sortBool = sort == 0 ? false : true
        
        var sortOptions = [YelpSortMode.BestMatched, YelpSortMode.Distance, YelpSortMode.HighestRated]
        var distanceOptions = [1, 5, 10]
        let metersConversionFactor = 1609
        var distanceVal = distanceOptions[distance] * metersConversionFactor
        Business.searchWithTerm("Restaurants", sort: sortOptions[sort], categories: categories, deals: sortBool, distance: distanceVal) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.tableView.reloadData()

        }
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        filtered = businesses.filter({ (text) -> Bool in
            var businessName = text.name
            if let businessName = businessName {
                let tmp: NSString = businessName
                let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
                return range.location != NSNotFound
            } else {
                return false
            }
        })
        
        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
 
        var business: Business?
        
        if (self.searchActive && self.filtered.count > 0) {
            business = self.filtered[indexPath.row]
        } else {
            business = self.businesses[indexPath.row]
        }
        
        self.business = business
        performSegueWithIdentifier("businessViewSegue", sender: self)

    
    }

}
