//
//  WeatherViewModel.swift
//  MobiquityWeatherApp
//
//  Created by Shafiullah, Mohammed (Cognizant) on .
//

import Foundation
import UIKit.UIImage

protocol WeatherFetchable {
    func getWeather(latitude: Double, longitude: Double)
    func getForecast(latitude: Double, longitude: Double)
}

class WeatherViewModel: WeatherFetchable {
    
    let locationName = Box("..")

    let description = Box("...")
    
    let temperature = Box("...")

    let humidity = Box("...")
    
    let icon: Box<UIImage?> = Box(nil)
    
    let date = Box("...")
       
    let wind = Box("...")

    let forecastCellViewModels = Box([ForeCastCollectionCellViewModel]())

    let error: Box<OpenWeatherMapError?> = Box(nil)

    func getWeather(latitude: Double, longitude: Double) {
        WeatherService.getCurrentWather(latitude: latitude, longitude: longitude) { (weather, error) in
            self.error.value = error
            guard let weather = weather else { return }
            self.locationName.value = weather.name
            self.description.value = weather.info.description
            self.temperature.value = "Temperature: \(weather.main.temp)"
            self.humidity.value = "humidty: \(weather.main.humidity)"
            self.date.value = weather.date
            self.wind.value = "Wind Speed: \(weather.wind.speed)"
            WeatherService.downloadImage(icon: weather.info.icon) { (image, imageError) in
                self.icon.value = image
            }
        }
    }
    
    func getForecast(latitude: Double, longitude: Double) {
        WeatherService.getforecast(latitude: latitude, longitude: longitude) { (forecast, error) in
            self.error.value = error
            guard let forecast = forecast else { return }
            self.buildCellViewModels(forecast: forecast.list)
        }
    }
    
    func buildCellViewModels(forecast: [WeatherForecast]) {
        var forecasts = [ForeCastCollectionCellViewModel]()
        for each in forecast {
            let forecastCellViewModels = ForeCastCollectionCellViewModel()
            forecastCellViewModels.temprature = each.main.temp
            forecastCellViewModels.humidity = each.main.humidity
            forecastCellViewModels.wind = each.main.pressure
            forecastCellViewModels.feelsLike = each.main.feelsLike

            WeatherService.downloadImage(icon: each.info.icon)
            { (image, imageError) in
                forecastCellViewModels.icon.value = image
            }
            forecasts.append(forecastCellViewModels)
        }
        forecastCellViewModels.value = forecasts
    }
}
