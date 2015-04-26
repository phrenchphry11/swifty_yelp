//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Holly French on 4/25/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

protocol FiltersViewControllerDelegate : class {
    func didChangeFilters(filtersViewController: FiltersViewController, filters: [String : NSObject])
}

enum FilterTypes : Int, Printable {
    case Categories, Sort, Distance, Deals
    
    var description : String {
        get {
            switch self {
            case .Categories:
                return "Categories"
            case .Sort:
                return "Sort by"
            case .Distance:
                return "Distance"
            case .Deals:
                return "Deals"
            }
        }
    }
    static let values = [Categories, Sort, Distance, Deals]
    static let count = values.count
    
    static func fromValue(index: Int) -> FilterTypes {
        return values[index]
    }
}

class FiltersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate, SegmentCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: FiltersViewControllerDelegate? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: "onCancelButton")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Search", style: .Plain, target: self, action: "onSearchButton")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.registerNib(UINib(nibName: "SwitchCell", bundle: nil), forCellReuseIdentifier: "SwitchCell")
        self.tableView.registerNib(UINib(nibName: "SegmentCell", bundle: nil), forCellReuseIdentifier: "SegmentCell")
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return FilterTypes.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return FilterTypes.fromValue(section).description
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case FilterTypes.Categories.rawValue:
                return Filter.count()
            case FilterTypes.Sort.rawValue, FilterTypes.Distance.rawValue, FilterTypes.Deals.rawValue:
                return 1
            default:
                return 0
        }
    }
    
    func didUpdateValue(switchCell: SwitchCell, value: Bool) {
        let indexPath = self.tableView.indexPathForCell(switchCell)!
        Filter.enableCategory(indexPath, enable: value)
    }
    
    func didUpdateSegmentValue(segmentCell: SegmentCell, value: Int) {
        let type = segmentCell.type!
        if (type == FilterTypes.Sort) {
            Filter.setSortBy(value)
        } else if (type == FilterTypes.Distance) {
            Filter.setDistance(value)
        } else {
            println("Error")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case FilterTypes.Categories.rawValue:
            let cell = self.tableView.dequeueReusableCellWithIdentifier("SwitchCell") as! SwitchCell
        
            cell.delegate = self
            cell.titleLabel.text = Filter.getName(indexPath)
            cell.setSwitchValue(Filter.isEnabledCategory(indexPath))
        
            return cell
        
        case FilterTypes.Sort.rawValue:
            let cell = self.tableView.dequeueReusableCellWithIdentifier("SegmentCell") as! SegmentCell
        
            cell.delegate = self
            cell.switchLabel.text = "Sort by"
            cell.type = FilterTypes.Sort
            cell.setSegmentValue(Filter.getSort())
            cell.segmentCell.setTitle("Best Match", forSegmentAtIndex: 0)
            cell.segmentCell.setTitle("Distance", forSegmentAtIndex: 1)
            cell.segmentCell.setTitle("Rating", forSegmentAtIndex: 2)
            return cell
        
        case FilterTypes.Distance.rawValue:
            let cell = self.tableView.dequeueReusableCellWithIdentifier("SegmentCell") as! SegmentCell
        
            cell.delegate = self
            cell.switchLabel.text = "Distance"
            cell.type = FilterTypes.Distance
            cell.setSegmentValue(Filter.getDistance())
            cell.segmentCell.setTitle("1 mi", forSegmentAtIndex: 0)
            cell.segmentCell.setTitle("5 mi", forSegmentAtIndex: 1)
            cell.segmentCell.setTitle("10 mi", forSegmentAtIndex: 2)
            return cell
        
        case FilterTypes.Deals.rawValue:
            let cell = self.tableView.dequeueReusableCellWithIdentifier("SwitchCell") as! SwitchCell
        
            cell.delegate = self
            cell.titleLabel.text = "Offering a Deal"
            cell.setSwitchValue(Filter.dealsEnabled())
            return cell
        
        default:
            return UITableViewCell()
        }
    }

    func onCancelButton() {
        self.navigationController?.popViewControllerAnimated(true)
    }

    func onSearchButton() {
        self.delegate!.didChangeFilters(self, filters: Filter.getFilters())
        self.navigationController?.popViewControllerAnimated(true)
    }
}
