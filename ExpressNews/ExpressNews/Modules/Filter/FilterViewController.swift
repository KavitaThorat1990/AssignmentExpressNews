//
//  FilterViewController.swift
//  ExpressNews
//
//  Created by Kavita Thorat on 03/01/24.
//

import UIKit

class FilterViewController: UIViewController {
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()

    private var categoriesTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.accessibilityIdentifier = Constants.AccessibilityIds.categoryTable
        return tableView
    }()
    
    private var optionsTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.accessibilityIdentifier = Constants.AccessibilityIds.optionTable
        return tableView
    }()
    
    private let bottomToolbar: UIToolbar = {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        return toolbar
    }()

    var filterOptionsUpdated: (([String: [String]]) -> Void)?
    var viewModel = FilterViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupUI()
    }

    func setupViewModel() {
        viewModel.filterOptionsUpdated = { [weak self] in
            self?.optionsTableView.reloadData()
        }
    }
    
    private func setupUI() {
        
        view.backgroundColor = .white

        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(bottomToolbar)
        bottomToolbar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomToolbar.topAnchor),
            
            bottomToolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomToolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomToolbar.heightAnchor.constraint(equalToConstant: 44),
            bottomToolbar.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])

        containerView.addSubview(categoriesTableView)
        categoriesTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            categoriesTableView.topAnchor.constraint(equalTo: containerView.topAnchor),
            categoriesTableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            categoriesTableView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.4),
            categoriesTableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])

        containerView.addSubview(optionsTableView)
        optionsTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            optionsTableView.topAnchor.constraint(equalTo: containerView.topAnchor),
            optionsTableView.leadingAnchor.constraint(equalTo: categoriesTableView.trailingAnchor, constant: 1.0),
            optionsTableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            optionsTableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])

        
        let clearAllButton = UIBarButtonItem(title: Constants.ButtonTitles.clearAll, style: .plain, target: self, action: #selector(clearAllButtonTapped))
        let applyButton = UIBarButtonItem(title: Constants.ButtonTitles.apply, style: .plain, target: self, action: #selector(applyFilterButtonTapped))

        bottomToolbar.items = [clearAllButton, UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), applyButton]

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
    @objc func applyFilterButtonTapped() {
        let selectedOptions = viewModel.getSelectedOptions()

        // Notify the callback closure with selected options
        filterOptionsUpdated?(selectedOptions)

        dismiss(animated: true, completion: nil)
    }
    
    @objc func clearAllButtonTapped() {
        viewModel.clearAllFilters()
    }
}
