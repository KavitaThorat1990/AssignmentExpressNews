//
//  FilterViewController.swift
//  ExpressNews
//
//  Created by Kavita Thorat on 03/01/24.
//

import UIKit

class FilterViewController: UIViewController {

    @IBOutlet private weak var categoriesTableView: UITableView! {
        didSet {
            categoriesTableView.accessibilityIdentifier = "categoriesTableView"
        }
    }
    @IBOutlet private weak var optionsTableView: UITableView! {
        didSet {
            optionsTableView.accessibilityIdentifier = "optionsTableView"
        }
    }
    var filterOptionsUpdated: (([String: [String]]) -> Void)?
    var viewModel: FilterViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupTableViews()
    }

    func setupViewModel() {
        viewModel = FilterViewModel()
        viewModel.filterOptionsUpdated = { [weak self] in
            self?.optionsTableView.reloadData()
        }
    }
    
    private func setupTableViews() {
        categoriesTableView.delegate = self
        categoriesTableView.dataSource = self

        optionsTableView.delegate = self
        optionsTableView.dataSource = self

        categoriesTableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.CellIds.categoryCell)
        optionsTableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.CellIds.optionCell)
    }
}

extension FilterViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == categoriesTableView {
            return viewModel.numberOfCategories()
        } else {
            return viewModel.numberOfOptions(for: viewModel.selectedCategoryIndex)
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == categoriesTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIds.categoryCell, for: indexPath)
            cell.textLabel?.text = viewModel.categoryTitle(for: indexPath.row)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIds.optionCell, for: indexPath)
            if let option = viewModel.option(for: indexPath) {
                cell.textLabel?.text = option.title
                cell.accessoryType = option.isSelected ? .checkmark : .none
            }
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == categoriesTableView {
            viewModel.selectedCategoryIndex = indexPath.row
            optionsTableView.reloadData()
        } else {
            viewModel.didSelectOption(at: indexPath)
            optionsTableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
}

extension FilterViewController {
    @IBAction func applyFilterButtonTapped() {
        let selectedOptions = viewModel.getSelectedOptions()

        // Notify the callback closure with selected options
        filterOptionsUpdated?(selectedOptions)

        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clearAllButtonTapped() {
        viewModel.clearAllFilters()
    }
}
