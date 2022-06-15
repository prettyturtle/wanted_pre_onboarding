//
//  Information.swift
//  wanted_pre_onboarding
//
//  Created by yc on 2022/06/12.
//

import Foundation

enum Information: String, CaseIterable {
    case temp
    case feelsLike
    case humidity
    case tempMin
    case tempMax
    case pressure
    case speed
    case description
    
    var title: String {
        switch self {
        case .temp: return "현재기온"
        case .feelsLike: return "체감기온"
        case .humidity: return "현재습도"
        case .tempMin: return "최저기온"
        case .tempMax: return "최고기온"
        case .pressure: return "기압"
        case .speed: return "풍속"
        case .description: return "날씨설명"
        }
    }
    
    func getInfo(weatherInfo: WeatherInfo?) -> String {
        guard let weatherInfo = weatherInfo else { return "" }
        switch self {
        case .temp: return weatherInfo.main.temp.celsius.temperatureFormat
        case .feelsLike: return weatherInfo.main.feelsLike.celsius.temperatureFormat
        case .humidity: return "\(weatherInfo.main.humidity)%"
        case .tempMin: return weatherInfo.main.tempMin.celsius.temperatureFormat
        case .tempMax: return weatherInfo.main.tempMax.celsius.temperatureFormat
        case .pressure: return "\(weatherInfo.main.pressure)㍱"
        case .speed: return "\(weatherInfo.wind.speed)/sec"
        case .description: return weatherInfo.weather.first?.description ?? ""
        }
    }
}
