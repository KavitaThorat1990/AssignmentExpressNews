//
//  FilterViewModel.swift
//  ExpressNews
//
//  Created by Kavita Thorat on 03/01/24.
//

import Foundation
import PromiseKit

struct FilterOption {
    let title: String
    var isSelected: Bool
    var value: String
}

struct FilterCategory {
    let title: String
    var options: [FilterOption]
}

class FilterViewModel {
    var categories: [FilterCategory] = []
    var selectedCategoryIndex = 0
    var filterOptionsUpdated: (() -> Void)?
    let filterOptionsUseCase: FilterOptionsUseCase

       init(filterOptionsUseCase: FilterOptionsUseCase = FilterOptionsAPI()) {
           self.filterOptionsUseCase = filterOptionsUseCase
           setupCategories()
       }

    func setupCategories() {
           // Load categories dynamically using FilterOptionsUseCase
           firstly {
               filterOptionsUseCase.loadFilterCategories()
           }.done { [weak self] categories in
               self?.categories = categories.map { FilterCategory(title: $0, options: []) }
               self?.loadOptionsForFilterCategory()
           }.catch { error in
               print("Error loading categories: \(error)")
           }
       }

    func loadOptionsForCategory(category: FilterCategory, index: Int) -> Promise<Void>{
        firstly {
            filterOptionsUseCase.loadCategories()
        }.done { [weak self] categories in
            let updatedCategory = FilterCategory(title: category.title, options: categories.map { FilterOption(title: $0, isSelected: false, value: $0) })
            self?.categories[index] = updatedCategory
        }
    }

    func loadOptionsForCountry(category: FilterCategory, index: Int) -> Promise<Void> {
        return firstly {
            filterOptionsUseCase.loadCountries()
        }.done { [weak self] countries in
            let updatedCategory = FilterCategory(title: category.title, options: countries.map { FilterOption(title: $0.name, isSelected: false, value: $0.code) })
            self?.categories[index] = updatedCategory
        }
    }

    func loadOptionsForLanguages(category: FilterCategory, index: Int) -> Promise<Void> {
        firstly {
            filterOptionsUseCase.loadLanguages()
        }.done { [weak self] languages in
            let updatedCategory = FilterCategory(title: category.title, options: languages.map { FilterOption(title: $0.name, isSelected: false, value: $0.code) })
            self?.categories[index] = updatedCategory
        }
    }

    func loadOptionsForSources(category: FilterCategory, index: Int) -> Promise<Void>{
        return firstly {
            filterOptionsUseCase.fetchSources()
        }.done { [weak self] sourcesResponse in
            let updatedCategory = FilterCategory(title: category.title, options: sourcesResponse.sources.map { FilterOption(title: $0.name, isSelected: false, value: $0.id) })
            self?.categories[index] = updatedCategory
        }
    }

    func loadOptionsForFilterCategory() {
        var promises: [Promise<Void>] = []
        for (index, category) in self.categories.enumerated() {
            switch category.title {
            case Constants.FilterCategories.category:
                promises.append(loadOptionsForCategory(category: category, index: index))
            case Constants.FilterCategories.country:
                promises.append(loadOptionsForCountry(category: category, index: index))
            case Constants.FilterCategories.language:
                promises.append(loadOptionsForLanguages(category: category, index: index))
            case Constants.FilterCategories.sources:
                promises.append(loadOptionsForSources(category: category, index: index))
            default:
                continue
            }
        }
        
        when(fulfilled: promises)
            .done { [weak self] in
                self?.filterOptionsUpdated?()
            }
    }

   func numberOfCategories() -> Int {
       return categories.count
   }

   func categoryTitle(for index: Int) -> String {
       if index < categories.count {
           return categories[index].title
       }
       return ""
   }

   func numberOfOptions(for index: Int) -> Int {
       if index < categories.count {
           return categories[index].options.count
       }
       return 0
   }

   func option(for indexPath: IndexPath) -> FilterOption? {
       if selectedCategoryIndex < categories.count, indexPath.row < categories[selectedCategoryIndex].options.count {
           return categories[selectedCategoryIndex].options[indexPath.row]
       }
       return nil
   }

   func indexFor(category: String) -> Int? {
       return categories.firstIndex {  $0.title == category }
   }

   func didSelectOption(at indexPath: IndexPath) {
       // Clear all selections in the language category
       guard selectedCategoryIndex < categories.count  else {
            return
       }
       
       if categories[selectedCategoryIndex].title != Constants.FilterCategories.sources {
           clearOptionsForCategory(at: selectedCategoryIndex)
       }
       
       handleSelectionForSources() // as per API doc mixing sources with country or category is not allowed
       
       var category = categories[selectedCategoryIndex]
       category.options[indexPath.row].isSelected.toggle()
       categories[selectedCategoryIndex] = category
       filterOptionsUpdated?()
   }
    
   func handleSelectionForSources() {
       if categories[selectedCategoryIndex].title == Constants.FilterCategories.sources {
            //clear selection for category and country
           if let indexForCategory = indexFor(category: Constants.FilterCategories.category) {
                clearOptionsForCategory(at: indexForCategory)
            }
           if let indexForCountry = indexFor(category: Constants.FilterCategories.country) {
                clearOptionsForCategory(at: indexForCountry)
            }
       } else if categories[selectedCategoryIndex].title == Constants.FilterCategories.category ||  categories[selectedCategoryIndex].title == Constants.FilterCategories.country{
            //clear selection for sources
           if let indexForSources = indexFor(category: Constants.FilterCategories.sources) {
                clearOptionsForCategory(at: indexForSources)
            }
        }
  }

  func clearAllFilters() {
        for (index, _) in categories.enumerated() {
            clearOptionsForCategory(at: index)
        }
        // Notify that options are updated after clearing all filters
        filterOptionsUpdated?()
  }

 func clearOptionsForCategory(at index: Int) {
        guard index < categories.count else { return }
        let category = categories[index]

        for (optionIndex, _) in category.options.enumerated() {
            categories[index].options[optionIndex].isSelected = false
        }
  }

  func getSelectedOptions() -> [String: [String]] {
        var selectedOptions: [String: [String]] = [:]

        for category in categories {
            let selectedCategoryOptions = category.options.filter { $0.isSelected }.map { $0.value }
            selectedOptions[category.title] = selectedCategoryOptions
        }

        return selectedOptions
  }
}
