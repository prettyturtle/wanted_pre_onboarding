//
//  CityTableViewCell.swift
//  wanted_pre_onboarding
//
//  Created by yc on 2022/06/15.
//

import UIKit

class CityTableViewCell: UITableViewCell {
    static let identifier = "CityTableViewCell"
    
    // MARK: - UI Components
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20.0, weight: .semibold)
        return label
    }()
    private lazy var currentTempLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16.0, weight: .medium)
        return label
    }()
    private lazy var currentHumidityLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16.0, weight: .medium)
        return label
    }()
    private lazy var disclosureIndicator: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        return imageView
    }()
    
    // MARK: - Setup Method
    func setupView(city: City) {
        setupAttribute()
        setupLayout()
        nameLabel.text = city.text
        fetchWeatherInfo(city: city)
    }
    
    // MARK: - PrepareForeReuse
    override func prepareForReuse() {
        iconImageView.image = nil
    }
}

// MARK: - Logics
private extension CityTableViewCell {
    /// 날씨 정보 API를 이용해 도시의 날씨 정보를 받아 화면을 갱신하는 메서드
    func fetchWeatherInfo(city: City) {
        Network().get(cityName: city.rawValue) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let weatherInfo):
                DispatchQueue.main.async {
                    self.updateView(info: weatherInfo)
                }
            case .failure(let error):
                print("ERROR: \(error.detail)")
            }
        }
    }
    
    /// 화면을 갱신하는 메서드
    ///
    /// 캐시된 정보가 있다면 캐시된 이미지를 활용한다.
    /// 캐시된 정보가 없다면 API로부터 이미지를 받아온다
    /// - info: 날씨 정보
    func updateView(info: WeatherInfo) {
        currentTempLabel.text = "🌡 \(info.main.temp)℃"
        currentHumidityLabel.text = "💧 \(info.main.humidity)%"
        
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
}

private extension CityTableViewCell {
    func setupAttribute() {
        contentView.backgroundColor = .systemBackground
    }
    func setupLayout() {
        [
            iconImageView,
            nameLabel,
            currentTempLabel,
            currentHumidityLabel,
            disclosureIndicator
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        let commonSpacing: CGFloat = 16.0
        
        [
            iconImageView
                .leadingAnchor
                .constraint(
                    equalTo: contentView.leadingAnchor,
                    constant: commonSpacing
                ),
            iconImageView
                .centerYAnchor
                .constraint(equalTo: contentView.centerYAnchor),
            iconImageView
                .widthAnchor
                .constraint(equalToConstant: 100.0),
            iconImageView
                .heightAnchor
                .constraint(equalToConstant: 100.0),
            nameLabel
                .leadingAnchor
                .constraint(
                    equalTo: iconImageView.trailingAnchor,
                    constant: commonSpacing
                ),
            nameLabel
                .topAnchor
                .constraint(equalTo: iconImageView.topAnchor),
            nameLabel
                .trailingAnchor
                .constraint(
                    equalTo: contentView.trailingAnchor,
                    constant: -commonSpacing
                ),
            currentTempLabel
                .leadingAnchor
                .constraint(equalTo: nameLabel.leadingAnchor),
            currentTempLabel
                .topAnchor
                .constraint(
                    equalTo: nameLabel.bottomAnchor,
                    constant: commonSpacing / 2.0
                ),
            currentTempLabel
                .trailingAnchor
                .constraint(
                    equalTo: contentView.trailingAnchor,
                    constant: -commonSpacing
                ),
            currentHumidityLabel
                .leadingAnchor
                .constraint(equalTo: nameLabel.leadingAnchor),
            currentHumidityLabel
                .topAnchor
                .constraint(
                    equalTo: currentTempLabel.bottomAnchor,
                    constant: commonSpacing / 2.0
                ),
            currentHumidityLabel
                .trailingAnchor
                .constraint(
                    equalTo: contentView.trailingAnchor,
                    constant: -commonSpacing
                ),
            disclosureIndicator
                .centerYAnchor
                .constraint(equalTo: contentView.centerYAnchor),
            disclosureIndicator
                .trailingAnchor
                .constraint(
                    equalTo: contentView.trailingAnchor,
                    constant: -commonSpacing
                )
        ].forEach { $0.isActive = true }
    }
}
