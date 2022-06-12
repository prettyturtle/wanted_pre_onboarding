//
//  CityListViewController.swift
//  wanted_pre_onboarding
//
//  Created by yc on 2022/06/12.
//

import UIKit

class CityListViewController: UIViewController {
    
    private lazy var cityTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: "cell"
        )
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupAttribute()
        setupLayout()
    }
}

// MARK: - UITableViewDelegate
extension CityListViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        let city = City.allCases[indexPath.row]
        let detailVC = DetailViewController(city: city)
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension CityListViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return City.allCases.count
    }
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "cell",
            for: indexPath
        ) as UITableViewCell
        cell.textLabel?.text = City.allCases[indexPath.row].text
        cell.accessoryType = .disclosureIndicator
        return  cell
    }
}

// MARK: - UI Methods
private extension CityListViewController {
    func setupNavigationBar() {
        navigationItem.title = "날씨☀️"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    func setupAttribute() {
        view.backgroundColor = .systemBackground
    }
    func setupLayout() {
        view.addSubview(cityTableView)
        
        let safeArea = view.safeAreaLayoutGuide
        
        cityTableView.translatesAutoresizingMaskIntoConstraints = false
        
        [
            cityTableView
                .topAnchor
                .constraint(equalTo: safeArea.topAnchor),
            cityTableView
                .leadingAnchor
                .constraint(equalTo: safeArea.leadingAnchor),
            cityTableView
                .trailingAnchor
                .constraint(equalTo: safeArea.trailingAnchor),
            cityTableView
                .bottomAnchor
                .constraint(equalTo: safeArea.bottomAnchor)
        ].forEach { $0.isActive = true }
    }
}
