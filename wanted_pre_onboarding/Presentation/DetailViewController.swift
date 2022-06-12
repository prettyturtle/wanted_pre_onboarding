//
//  DetailViewController.swift
//  wanted_pre_onboarding
//
//  Created by yc on 2022/06/12.
//

import UIKit

class DetailViewController: UIViewController {
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 4.0
        return imageView
    }()
    private lazy var weatherInfoTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.register(
            InfoTableViewCell.self,
            forCellReuseIdentifier: InfoTableViewCell.identifier
        )
        return tableView
    }()
    private lazy var activityIndicator = UIActivityIndicatorView(style: .large)
    
    private let city: City
    private let informations = Information.allCases
    private var weatherInfo: WeatherInfo?
    
    init(city: City) {
        self.city = city
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupAttribute()
        setupLayout()
        fetchWeatherInfo()
    }
}

// MARK: - UITableViewDataSource
extension DetailViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return informations.count
    }
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: InfoTableViewCell.identifier,
            for: indexPath
        ) as? InfoTableViewCell else { return UITableViewCell() }
        let title = informations[indexPath.row].title
        let value = informations[indexPath.row].getInfo(weatherInfo: weatherInfo)
        cell.setupView(title: title, value: value)
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - Logics
private extension DetailViewController {
    func fetchWeatherInfo() {
        activityIndicator.startAnimating()
        Network().get(cityName: city.rawValue) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let weatherInfo):
                DispatchQueue.main.async {
                    self.updateView(info: weatherInfo)
                    self.activityIndicator.stopAnimating()
                }
            case .failure(let error):
                print("ERROR \(error.localizedDescription)")
            }
        }
    }
    
    func updateView(info: WeatherInfo) {
        weatherInfo = info
        weatherInfoTableView.reloadData()
        let icon = fetchImage(icon: info.weather.first?.icon)
        iconImageView.image = icon
    }
    
    func fetchImage(icon: String?) -> UIImage? {
        guard let icon = icon else { return nil }
        let urlString = "https://openweathermap.org/img/wn/\(icon)@2x.png"
        guard let url = URL(string: urlString) else { return nil }
        do {
            let data = try Data(contentsOf: url)
            let image = UIImage(data: data)
            return image
        } catch {
            return nil
        }
    }
}

// MARK: - @objc Methods
private extension DetailViewController {
    @objc func didTapRefreshButton() {
        fetchWeatherInfo()
    }
}

// MARK: - UI Methods
private extension DetailViewController {
    func setupNavigationBar() {
        navigationItem.title = "\(city.text)의 날씨 정보"
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "arrow.triangle.2.circlepath"),
            style: .plain,
            target: self,
            action: #selector(didTapRefreshButton)
        )
    }
    func setupAttribute() {
        view.backgroundColor = .systemBackground
    }
    func setupLayout() {
        [
            iconImageView,
            weatherInfoTableView,
            activityIndicator
        ].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let safeArea = view.safeAreaLayoutGuide
        let commonSpacing: CGFloat = 16.0
        [
            iconImageView.widthAnchor.constraint(equalToConstant: 150.0),
            iconImageView.heightAnchor.constraint(equalToConstant: 150.0),
            iconImageView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            iconImageView.topAnchor.constraint(
                equalTo: safeArea.topAnchor,
                constant: commonSpacing
            ),
            weatherInfoTableView.topAnchor.constraint(
                equalTo: iconImageView.bottomAnchor,
                constant: commonSpacing)
            ,
            weatherInfoTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            weatherInfoTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            weatherInfoTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor)
        ].forEach { $0.isActive = true }
        
    }
}
