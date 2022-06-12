//
//  Network.swift
//  wanted_pre_onboarding
//
//  Created by yc on 2022/06/12.
//

import Foundation

struct Network {
    
    private let urlString = "https://api.openweathermap.org/data/2.5/weather"
    
    func get(cityName: String, completion: @escaping (Result<WeatherInfo, Error>) -> Void) {
        var urlComponents = URLComponents(string: urlString)
        urlComponents?.queryItems = [
            URLQueryItem(name: "q", value: cityName),
            URLQueryItem(name: "appid", value: "72b679ddb227219023234c815867edb3")
        ]
        
        guard let url = urlComponents?.url else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let data = data {
                do {
                    let weatherInfo = try JSONDecoder().decode(WeatherInfo.self, from: data)
                    completion(.success(weatherInfo))
                } catch {
                    completion(.failure(error))
                }
                return
            }
        }
        task.resume()
    }
}
