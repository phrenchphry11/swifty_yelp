//
//  Filter.swift
//  Yelp
//
//  Created by Holly French on 4/25/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//


struct Filter {
    private static var selectedCategories: [NSDictionary : Bool] = [:]

    private static let categories = [
        ["name" : "Afghan", "code": "afghani"],
        ["name" : "African, New", "code": "african"],
        ["name" : "American, New", "code": "newamerican"],
        ["name" : "Arabian", "code": "arabian"],
        ["name" : "Sandwiches", "code": "sandwiches"],
        ["name" : "Soup", "code": "soup"],
        ["name" : "Vegan", "code": "vegan"],
        ["name" : "Vietnamese", "code": "vietnamese"]
    ]
    
    private static var filters: [String : NSObject] = [
        "categories": [],
        "deals" : false,
        "distance" : 0,
        "sort": 0
    ]
    
    static func getName(indexPath: NSIndexPath) -> String {
        return self.categories[indexPath.row]["name"]! as String
    }
    
    static func getCode(indexPath: NSIndexPath) -> String {
        return self.categories[indexPath.row]["code"]! as String
    }
    
    static func isEnabledCategory(indexPath: NSIndexPath) -> Bool {
        let selectedKey = self.categories[indexPath.row]
        return self.selectedCategories[selectedKey] == true
    }
    
    static func enableCategory(indexPath: NSIndexPath, enable: Bool) {
        let selectedKey = self.categories[indexPath.row]
        
        if (indexPath.section == FilterTypes.Deals.rawValue) {
            self.setDeals(enable)
            return
        }
        
        if (enable) {
            self.selectedCategories[selectedKey] = true
        } else {
            self.selectedCategories.removeValueForKey(selectedKey)
        }
        
        self.filters["categories"] = self.selectedCategoryNames()
    }
        
    static func getFilters() -> [String : NSObject] {
        return self.filters
    }
    
    static func count() -> Int {
        return self.categories.count
    }
    
    private static func selectedCategoryNames() -> [String] {
        var categoryCodes: [String] = []
        
        for (category, found) in self.selectedCategories {
            if found {
                let categoryCode = (category as NSDictionary)["code"] as! String
                categoryCodes.append(categoryCode)
            }
        }
        
        return categoryCodes
    }
    
    static func setSortBy(indexPath: Int) {
        self.filters["sort"] = indexPath
    }
    
    static func getSort() -> Int {
        return filters["sort"] as! Int
    }
    
    static func setDistance(indexPath: Int) {
        self.filters["distance"] = indexPath
    }
    
    static func getDistance() -> Int {
        return filters["distance"] as! Int
    }
    
    static func setDeals(value: Bool) {
        filters["deals"] = value
    }
    
    static func dealsEnabled() -> Bool {
        return filters["deals"] as! Bool
    }
    
}
