//
//  DetailViewController.swift
//  wanted_pre_onboarding
//
//  Created by yc on 2022/06/12.
//

import UIKit

class DetailViewController: UIViewController {
    
    // MARK: - UI Components
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
    
    // MARK: - Properties
    private let city: City
    private let informations = Information.allCases
    private var weatherInfo: WeatherInfo?
    
    // MARK: - init
    init(city: City) {
        self.city = city
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
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
    /// 날씨 정보 API를 이용해 도시의 날씨 정보를 받아 화면을 갱신하는 메서드
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
                self.showAlert(title: "에러", message: "\(error.detail)")
            }
        }
    }
    
    /// 화면을 갱신하는 메서드
    ///
    /// 캐시된 정보가 있다면 캐시된 이미지를 활용한다.
    /// 캐시된 정보가 없다면 API로부터 이미지를 받아온다
    /// - info: 날씨 정보
    func updateView(info: WeatherInfo) {
        weatherInfo = info
        weatherInfoTableView.reloadData()
        guard let icon = info.weather.first?.icon else { return }
        
        if checkCachedImage(icon: icon) {
            let image = ImageCacheManager.shared.object(forKey: icon as NSString)
            iconImageView.image = image
        } else {
            DispatchQueue.global(qos: .background).async {
                guard let image = self.fetchImage(icon: icon) else { return }
                self.saveCacheImage(image: image, key: icon)
                DispatchQueue.main.async {
                    self.iconImageView.image = image
                }
            }
        }
    }
    
    /// 아이콘 이름으로 이미지를 받아오는 메서드
    ///
    /// - icon: 아이콘 이름
    func fetchImage(icon: String) -> UIImage? {
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
    
    /// 캐시된 이미지가 있는지 확인하여 Bool값을 반환하는 메서드
    ///
    /// - icon: 아이콘 이름
    func checkCachedImage(icon: String) -> Bool {
        if ImageCacheManager.shared.object(forKey: icon as NSString) != nil {
            return true
        } else {
            return false
        }
    }
    
    /// 이미지를 캐싱하는 메서드
    ///
    /// - image: 저장할 이미지
    /// - key: 저장할 키 값
    func saveCacheImage(image: UIImage, key: String) {
        ImageCacheManager.shared.setObject(image, forKey: key as NSString)
    }
    
    /// 날씨 정보를 받아오는 도중에 에러가 발생할 경우, 얼럿을 띄우는 메서드
    ///
    /// - title: 얼럿에 보여질 타이틀
    /// - message: 얼럿에 보여질 에러 설명
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(okAction)
        present(alertController, animated: true)
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
