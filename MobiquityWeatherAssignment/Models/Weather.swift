//
//  Weather.swift
//  MobiquityWeatherApp
//
//  Created by Shafiullah, Mohammed (Cognizant) on .
//


import UIKit

struct Weather: Codable {
    let id: Int
    let name: String
    let weatherInfo: [WeatherInfo]
    let coordinate: WeatherCoordinate
    let main: WeatherMain
    let datetime: Double
    let wind: Wind

    private enum CodingKeys : String, CodingKey {
        case id, name, coordinate = "coord", main, weatherInfo = "weather", datetime = "dt", wind
    }
    
    var info: WeatherInfo {
        weatherInfo[0]
    }
    
    var date: String {
        let date = Date(timeIntervalSince1970: datetime)
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.medium
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeZone = .current
        return dateFormatter.string(from: date)
    }
}

struct WeatherCoordinate: Codable {
    let lon: Double
    let lat: Double
}

struct WeatherMain: Codable {
    let temperature: Double
    let feelsLike: Double
    let pressure: Int
    let humidity: Int
    let temperatureMin: Double
    let temperatureMax: Double
   // let date:String
    
    private enum CodingKeys : String, CodingKey {
        case temperature = "temp", feelsLike = "feels_like", pressure, humidity, temperatureMin = "temp_min", temperatureMax = "temp_max" 
    }
    
    private let tempFormatter: NumberFormatter = {
      let tempFormatter = NumberFormatter()
      tempFormatter.numberStyle = .decimal
      return tempFormatter
    }()
    
    var temp: String {
        self.tempFormatter.string(from: temperature as NSNumber) ?? ""
    }
}

struct Wind: Codable {
    let speed: Double
    let degree: Double
    private enum CodingKeys : String, CodingKey {
      case speed, degree = "deg"
    }
}

struct WeatherInfo: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct WeatherForecast: Codable {
    let weatherInfo: [WeatherInfo]
    let main: WeatherMain
    var info: WeatherInfo {
        weatherInfo[0]
    }
    private enum CodingKeys : String, CodingKey {
      case main, weatherInfo = "weather"
    }
}
