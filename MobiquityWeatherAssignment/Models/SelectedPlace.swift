//
//  SelectedPlace.swift
//  MobiquityWeatherApp
//
//  Created by Shafiullah, Mohammed (Cognizant) on .
//

import UIKit

class SelectedPlace {
    var name: String = ""
    var longitude: Double = 0
    var latitude: Double = 0
    
    init(name: String, latitude: Double, longitude: Double) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
}


