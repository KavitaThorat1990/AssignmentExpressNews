//
//  Constants.swift
//  ExpressNews
//
//  Created by Kavita Thorat on 04/01/24.
//

import Foundation

struct Constants {
    
    static let defaultCategories = ["Sports"] //, "Entertainment", "Technology", "Business", "Science", "Health", "General"]
    static let pageSizeForFeatured = 10
    static let pageSizeForHome = 5
    static let pageSizeForNewsList = 20
    static let defaultCountry = "in"
    static let timeInterval = 5.0
    
    struct CellHeights {
        static let featuredCell = 200.0
        static let newsCell = 80.0
        static let categoryHeader = 44.0
    }
    
    struct CellIds {
        static let categoryCell = "CategoryCell"
        static let optionCell = "OptionCell"
    }
    
    struct ScreenTitles {
        static let home = "Home"
        static let newsList = "News List"
        static let search = "Search"
        static let sortBy = "Sort By"
    }
    
    struct ButtonTitles {
        static let cancel = "Cancel"
    }
    
    struct PayloadKeys {
        static let category = "category"
        static let newsArticle = "newsArticle"
    }
    
    struct FilterCategories {
    static let category = "Category"
    static let country = "Country"
    static let language = "Language"
    static let sources = "Sources"
    }
    
    struct DateFormats {
        static let newsDateFormat = "h.mm a z, EEEE, MMM d, yyyy"
    }
}
