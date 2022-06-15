//
//  CityListViewController.swift
//  wanted_pre_onboarding
//
//  Created by yc on 2022/06/12.
//

import UIKit

class CityListViewController: UIViewController {
    
    // MARK: - UI Components
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(
            self,
            action: #selector(beginRefresh),
            for: .valueChanged
        )
        return refreshControl
    }()
    private lazy var cityTableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 150.0
        tableView.refreshControl = refreshControl
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            CityTableViewCell.self,
            forCellReuseIdentifier: CityTableViewCell.identifier
        )
        return tableView
    }()
    
    // MARK: - Life Cycle
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
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CityTableViewCell.identifier,
            for: indexPath
        ) as? CityTableViewCell else { return UITableViewCell() }
        let city = City.allCases[indexPath.row]
        cell.selectionStyle = .none
        cell.setupView(city: city)
        return  cell
    }
}

// MARK: - @objc Methods
private extension CityListViewController {
    @objc func beginRefresh() {
        cityTableView.reloadData()
        refreshControl.endRefreshing()
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
