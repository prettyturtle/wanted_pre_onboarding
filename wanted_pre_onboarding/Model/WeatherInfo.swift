//
//  WeatherInfo.swift
//  wanted_pre_onboarding
//
//  Created by yc on 2022/06/12.
//

import Foundation

struct WeatherInfo: Decodable {
    let weather: [Weather]
    let main: Main
    let name: String
    let wind: Wind
    
    struct Weather: Decodable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }
    
    struct Main: Decodable {
        let temp: Double
        let feelsLike: Double
        let tempMin: Double
        let tempMax: Double
        let pressure: Int
        let humidity: Int
        
        enum CodingKeys: String, CodingKey {
            case temp, pressure, humidity
            case feelsLike = "feels_like"
            case tempMin = "temp_min"
            case tempMax = "temp_max"
        }
    }
    
    struct Wind: Decodable {
        let speed: Double
        let deg: Int
        let gust: Double?
    }
}
