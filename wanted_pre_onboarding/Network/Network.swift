//
//  Network.swift
//  wanted_pre_onboarding
//
//  Created by yc on 2022/06/12.
//

import Foundation

enum WeatherError: Error {
    case A
    case B
    
    var detail: String {
        switch self {
        case .A: return "유효하지 않은 URL입니다."
        case .B: return "날씨 정보 복호화에 실패했습니다."
        }
    }
}

struct Network {
    private let urlString = "https://api.openweathermap.org/data/2.5/weather"
    
    func get(cityName: String, completion: @escaping (Result<WeatherInfo, WeatherError>) -> Void) {
        var urlComponents = URLComponents(string: urlString)
        urlComponents?.queryItems = [
            URLQueryItem(name: "q", value: cityName),
            URLQueryItem(name: "lang", value: "kr"),
            URLQueryItem(name: "appid", value: "72b679ddb227219023234c815867edb3")
        ]
        
        guard let url = urlComponents?.url else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let _ = error {
                completion(.failure(WeatherError.A))
                return
            }
            if let data = data {
                do {
                    let weatherInfo = try JSONDecoder().decode(WeatherInfo.self, from: data)
                    completion(.success(weatherInfo))
                } catch {
                    completion(.failure(WeatherError.B))
                }
                return
            }
        }
        task.resume()
    }
}


