//
//  SearchLocation.swift
//  MobiquityWeatherAssignment
//
//  Created by Shafiullah, Mohammed (Cognizant) on .
//

import UIKit
import MapKit

class SearchLocation: UIViewController
{
    @IBOutlet weak var locationTableView: UITableView!
    var search: UISearchController!
    var matchingItems: [MKMapItem] = []
    var didSelctedPlace: ((SelectedPlace) -> Void)?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        search = UISearchController(searchResultsController: nil)
        search.obscuresBackgroundDuringPresentation = false
        search.searchResultsUpdater = self
        search.searchBar.placeholder = "Select City"
        navigationItem.searchController = search
    }
    
}

extension SearchLocation : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchBarText = searchController.searchBar.text else { return }
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBarText
        request.pointOfInterestFilter = MKPointOfInterestFilter(excluding: [])
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response else {
                return
            }
            self.matchingItems = response.mapItems
            self.locationTableView.reloadData()
        }
    }
}


extension SearchLocation: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let selectedItem = matchingItems[indexPath.row].placemark
        cell.textLabel?.text = selectedItem.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }
}

extension SearchLocation: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = matchingItems[indexPath.row].placemark
        let place = SelectedPlace(name: selectedItem.name ?? "", latitude: selectedItem.coordinate.latitude, longitude: selectedItem.coordinate.longitude)
        didSelctedPlace?(place)
        self.navigationController?.dismiss(animated: false, completion: nil)
    }
}

