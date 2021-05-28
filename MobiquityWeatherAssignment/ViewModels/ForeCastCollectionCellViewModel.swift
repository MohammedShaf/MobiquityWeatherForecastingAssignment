//
//  ForeCastCollectionCellViewModel.swift
//  MobiquityWeatherApp
//
//  Created by Shafiullah, Mohammed (Cognizant) on .
//
import UIKit

class ForeCastCollectionCellViewModel
{
    //var dateAndTime: String!
    var temprature: String!
    var humidity :Int!
    var wind : Int!
    var feelsLike : Double!
    var tableViewHideShowBool = false
    
    let icon: Box<UIImage?> = Box(nil)
}
