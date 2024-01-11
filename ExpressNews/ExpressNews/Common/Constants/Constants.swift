//
//  Constants.swift
//  ExpressNews
//
//  Created by Kavita Thorat on 04/01/24.
//

import Foundation

struct Constants {
    
    static let defaultCategories = ["Sports", "Entertainment"] //, "Entertainment", "Technology", "Business", "Science", "Health", "General"]
    static let pageSizeForFeatured = 10
    static let pageSizeForHome = 5
    static let pageSizeForNewsList = 20
    static let defaultCountry = "in"
    static let timeInterval = 5.0
    
    struct CellHeights {
        static let featuredCell = 200.0
        static let newsCell = 120.0
        static let categoryHeader = 44.0
    }
    
    struct CellIds {
        static let categoryCell = "CategoryCell"
        static let optionCell = "OptionCell"
        static let newsCell = "NewsCell"
        static let featuredNewsItemCell = "FeaturedNewsItemCell"
        static let newsCategoryHeader = "NewsCategoryHeader"
        static let featuredNewsCell = "FeaturedNewsCell"
        static let newsDetailsCell = "NewsDetailsCell"        
    }
    
    struct ScreenTitles {
        static let home = "Home"
        static let newsList = "News List"
        static let search = "Search"
        static let sortBy = "Sort By"
    }
    
    struct ButtonTitles {
        static let cancel = "Cancel"
        static let filter = "Filter"
        static let sort = "Sort"
        static let clearAll = "Clear All"
        static let apply = "Apply"
        static let seeAll = "See All"
        static let seeMore = "See More"
    }
    
    struct AccessibilityIds {
        static let optionTable = "optionsTableView"
        static let categoryTable = "categoriesTableView"
        static let seeAllButton = "SeeAll"
        static let filterButton = "Filter"
    }
    
    struct ImageNames {
        static let filter = "line.3.horizontal.decrease"
        static let sort = "arrow.down.and.line.horizontal.and.arrow.up"
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
