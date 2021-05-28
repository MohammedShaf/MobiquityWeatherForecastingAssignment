//
//  ForeCastingViewController.swift
//  MobiquityWeatherAssignment
//
//  Created by Shafiullah, Mohammed (Cognizant) on .
//

import UIKit

class ForeCastingViewController: UIViewController
{
    @IBOutlet weak var foreCastingTableView: UITableView!
    var forecast: ForeCastCollectionCellViewModel!
    private let viewModel = WeatherViewModel()
    var location: Place!
    var selectedLocationName = ""
    var selectedDiscription = ""
    var ContinousString = ""

    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupUI()
        viewModel.getWeather(latitude: location.lat, longitude: location.lng)
        setupViews()
        viewModel.getForecast(latitude: location.lat, longitude: location.lng)
    }
    
    @IBAction func BackButton(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupUI()
    {
        foreCastingTableView.estimatedRowHeight = 50
        foreCastingTableView.rowHeight = UITableView.automaticDimension
    }
  
    func setupViews() {
        viewModel.locationName.bind {[weak self] (locationName) in
            self?.selectedLocationName = locationName
        }
        
        viewModel.description.bind {[weak self] (description) in
            self?.selectedDiscription = description
        }
        
        viewModel.temperature.bind {[weak self] (temp) in
            self?.ContinousString =  self?.ContinousString ?? "" + "Temperature : "+temp
        }
        
        viewModel.date.bind {[weak self] (date) in
            self?.ContinousString =  self?.ContinousString ?? "" + "Date : "+date
        }
        
        viewModel.humidity.bind {[weak self] (humidity) in
            self?.ContinousString =  self?.ContinousString ?? "" + "Humidity : "+humidity

        }
        
//        viewModel.icon.bind {[weak self] (icon) in
//            self?.imageView.image = icon
//        }
        
        viewModel.wind.bind {[weak self] (wind) in
            self?.ContinousString =  self?.ContinousString ?? "" + "Wind : "+wind
        }

        viewModel.forecastCellViewModels.bind {[weak self] (forecast) in
            self?.foreCastingTableView.reloadData()
        }
    }
}

extension ForeCastingViewController: UITableViewDataSource, UITableViewDelegate
{
    //MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // return dataSource.count;
        return viewModel.forecastCellViewModels.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ForeCastTableViewCell
      
        cell.titleLabel.text = selectedLocationName
        let forecast = viewModel.forecastCellViewModels.value[indexPath.row]
        cell.setValues(forecast)
        //cell.forecast = forecast
        return cell
    }

    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let forecast = viewModel.forecastCellViewModels.value[indexPath.row]
        let tableViewHideShowBool = forecast.tableViewHideShowBool
        forecast.tableViewHideShowBool = !tableViewHideShowBool
        tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
    }
}

class ForeCastTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var subtitleLabel : UILabel!
    @IBOutlet weak var descriptionLabel : UILabel!
    @IBOutlet weak var icon : UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setValues(_ foreCastCollectionCellViewModel: ForeCastCollectionCellViewModel) {
    self.titleLabel.text = "TEMPRATURE: " + foreCastCollectionCellViewModel.temprature.description + "\n"
        
        self.subtitleLabel.text = "Weather Status: " + foreCastCollectionCellViewModel.feelsLike.description + "\n"
        
        self.descriptionLabel.text = "HUMIDITY: " + foreCastCollectionCellViewModel.humidity.description + "\n" + "PRESSURE: "
         + foreCastCollectionCellViewModel.wind.description
        
        let tableViewHideShowBool = foreCastCollectionCellViewModel.tableViewHideShowBool
        self.descriptionLabel.isHidden = !tableViewHideShowBool
        
        //self.icon.image = tableViewHideShowBool ? UIImage(named: "up") : UIImage(named: "down")
    }
}
