//
//  WeatherService.swift
//  MobiquityWeatherApp
//
//  Created by Shafiullah, Mohammed (Cognizant) on .
//
import Foundation
import UIKit.UIImage

enum OpenWeatherMapError: Error {
  case invalidResponse
  case noData
  case failedRequest
  case invalidData
}

struct WeatherService {
    
    typealias WeatherDataCompletion = (Weather?, OpenWeatherMapError?) -> ()
    typealias imageCompletion = (UIImage?, OpenWeatherMapError?) -> ()
    typealias WeatherForecastCompletion = (WeatherForecastInfo?, OpenWeatherMapError?) -> ()

    private static let apiKey = "fae7190d7e6433ec3a45285ffcf55c86"
    private static let host = "api.openweathermap.org"
    private static let path = "/data/2.5/weather"
    private static let forecastPath = "/data/2.5/forecast"
    private static let imageHost = "openweathermap.org"
    private static let imagePath = "/img"
    
    static func getCurrentWather(latitude: Double, longitude: Double, completion: @escaping WeatherDataCompletion) {
        var urlBuilder = URLComponents()
        urlBuilder.scheme = "http"
        urlBuilder.host = host
        urlBuilder.path = path
        urlBuilder.queryItems = [
            URLQueryItem(name: "lat", value: "\(latitude)"),
            URLQueryItem(name: "lon", value: "\(longitude)"),
            URLQueryItem(name: "appid", value: apiKey)
        ]
        
        let url = urlBuilder.url!
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                do {
                    let decoder = JSONDecoder()
                    let weatherData = try decoder.decode(Weather.self, from: data!)
                    completion(weatherData, nil)
                } catch {
                    print("Unable to decode openweathermap response: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
    
    static func getforecast(latitude: Double, longitude: Double, completion: @escaping WeatherForecastCompletion) {
        var urlBuilder = URLComponents()
        urlBuilder.scheme = "http"
        urlBuilder.host = host
        urlBuilder.path = forecastPath
        urlBuilder.queryItems = [
            URLQueryItem(name: "lat", value: "\(latitude)"),
            URLQueryItem(name: "lon", value: "\(longitude)"),
            URLQueryItem(name: "appid", value: apiKey)
        ]
        
        let url = urlBuilder.url!
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                do {
                    let decoder = JSONDecoder()
                    let forecast = try decoder.decode(WeatherForecastInfo.self, from: data!)
                    completion(forecast, nil)
                } catch let error {
                    switch error as? DecodingError {
                    case .typeMismatch(let key, let value):
                        print("error \(key), value \(value) and ERROR: \(error.localizedDescription)")
                    case .valueNotFound(let key, let value):
                        print("error \(key), value \(value) and ERROR: \(error.localizedDescription)")
                    case .keyNotFound(let key, let value):
                        print("error \(key), value \(value) and ERROR: \(error.localizedDescription)")
                    case .dataCorrupted(let key):
                        print("error \(key), and ERROR: \(error.localizedDescription)")
                    default:
                        print("ERROR: \(error.localizedDescription)")
                    }
                }
            }
        }.resume()
    }
    
    static func downloadImage(icon: String, completion: @escaping imageCompletion) {
        let url = URL(string: "http://openweathermap.org/img/wn/\(icon).png")!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if let data = data {
                    let image = UIImage(data: data)
                    completion(image, nil)
                } else {
                    completion(nil, .noData)
                }
            }
        }.resume()
    }
}
