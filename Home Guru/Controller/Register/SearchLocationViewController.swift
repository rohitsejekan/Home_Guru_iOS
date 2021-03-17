//
//  SearchLocationViewController.swift
//  Home Guru
//
//  Created by Priya Vernekar on 10/11/20.
//  Copyright © 2020 Priya Vernekar. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire
import SwiftyJSON
var g_lat: String!
var g_long: String!
var g_address: String!
var g_addressDetails: GMSAddress?

protocol LocateOnTheMap {
    func locateWithLong(lon: String, andLatitude lat: String, andAddress address: String)
}

class SearchLocationViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, MapActionsProtocol {
    
    @IBOutlet weak var searchLocationOuterView: UIView!
    @IBOutlet weak var searchBarOuterView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    //variables
    var placeIDArray = [String]()
    var resultsArray = [String]()
    var primaryAddressArray = [String]()
    var searchResults = [String]()
    var searhPlacesName = [String]()
    //    let googleAPIKey = "AIzaSyCbUaNMEhxu11BmllfCa0Gg3AAZPz9ZjF0"
    var delegate: LocateOnTheMap?
    //search Controller implementations
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        tableViewSetup()
        
    }
    
    override func viewWillLayoutSubviews() {
        searchLocationOuterView.roundCorners(radius: 30.0, corners: [.topLeft,.topRight])
        setSearchController()
    }
    
    @IBAction func useCurrentLocationAction(_ sender: UIButton) {
        let vc = Constants.mainStoryboard.instantiateViewController(withIdentifier: "MapViewController") as? MapViewController
        delegate = vc!
        vc!.delegate = self
        self.present(vc!, animated: true, completion: nil)
    }
    
    @IBAction func closePopUpAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //    func tableViewSetup(){
    //        self.tableView.delegate = self
    //        self.tableView.dataSource = self
    //        self.tableView.tableHeaderView = searchController.searchBar
    //        self.tableView.backgroundColor = UIColor.white
    //    }
    func setSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Location"
        searchController.searchBar.sizeToFit()
        let customSearchBar = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 36))
        customSearchBar.layer.cornerRadius = 8
        customSearchBar.clipsToBounds = true
        //customSearchBar.backgroundColor = UIColor.white
        searchController.searchBar.setSearchFieldBackgroundImage(customSearchBar.asImage(), for: .normal)
        searchController.searchBar.layer.cornerRadius = searchController.searchBar.frame.size.height/2
        searchController.searchBar.layer.masksToBounds = true
      
        searchController.searchBar.backgroundColor = ColorPalette.homeGuruBlueColor
        searchController.searchBar.layer.borderWidth = 1.0
        searchController.searchBar.setBackgroundImage(customSearchBar.asImage(), for: .any, barMetrics: .default)
        searchBarOuterView.addSubview(searchController.searchBar)
        definesPresentationContext = true
    }
    
    func dismissPopUp() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForTextSearch(searchText: String){
//        placeAutocomplete(text_input: searchText)
        self.tableView.reloadSections(NSIndexSet(index: 0) as IndexSet, with: .automatic)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchController.searchBar.showsCancelButton = true
        self.tableView.reloadSections(NSIndexSet(index: 0) as IndexSet, with: .automatic)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        self.tableView.reloadSections(NSIndexSet(index: 0) as IndexSet, with: .automatic)
    }
    func isFiltering() -> Bool{
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchBarIsEmpty()){
            searchBar.text = ""
        }else{
//            placeAutocomplete(text_input: searchText)
            
        }
    }
    
    
    //Table view methods to be implemented
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = searchResults[indexPath.row]
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.numberOfLines = 0
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let correctedAddress = self.resultsArray[indexPath.row].addingPercentEncoding(withAllowedCharacters: .symbols) else {
            print("Error. cannot cast name into String")
            return
        }
        
        print(correctedAddress)
        let urlString =  "https://maps.googleapis.com/maps/api/geocode/json?address=\(correctedAddress)&sensor=false&key=\(Constants.googleApiKey)"
        
        let url = URL(string: urlString)
        
        AF.request(url!, method: .get, headers: nil)
            .validate()
            .responseJSON { (response) in
                switch response.result {
                case.success(let value):
                    let json = JSON(value)
                    
                    let lat = json["results"][0]["geometry"]["location"]["lat"].rawString()
                    let lng = json["results"][0]["geometry"]["location"]["lng"].rawString()
                    let formattedAddress = json["results"][0]["formatted_address"].rawString()
                    
                    g_lat = lat
                    g_long = lng
                    g_address = formattedAddress
                    // store this also g_addressDetails see in api response
                    print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
                    print(g_lat,g_long,g_address)
                    //                    self.delegate?.locateWithLong(lon: g_lat, andLatitude: g_long, andAddress: g_address)
                    self.dismiss(animated: true, completion: nil)
                    
                    
                case.failure(let error):
                    print("\(error.localizedDescription)")
                }
                
                
        }
        
    }
    
    
    
    //function for autocomplete
//    func placeAutocomplete(text_input: String) {
//        let filter = GMSAutocompleteFilter()
//        let placesClient = GMSPlacesClient()
//        filter.type = .establishment
//        
//        
//        //geo bounds set for karntaka region
//        let bounds = GMSCoordinateBounds(coordinate: CLLocationCoordinate2D(latitude: 13.001356, longitude: 75.174399), coordinate: CLLocationCoordinate2D(latitude: 13.343668, longitude: 80.272055))
//        
//        placesClient.autocompleteQuery(text_input, bounds: bounds, filter: nil) { (results, error) -> Void in
//            self.placeIDArray.removeAll()
//            self.resultsArray.removeAll()
//            self.primaryAddressArray.removeAll()
//            if let error = error {
//                print("Autocomplete error \(error)")
//                return
//            }
//            if let results = results {
//                for result in results {
//                    self.primaryAddressArray.append(result.attributedPrimaryText.string)
//                    //print("primary text: \(result.attributedPrimaryText.string)")
//                    //print("Result \(result.attributedFullText) with placeID \(String(describing: result.placeID!))")
//                    self.resultsArray.append(result.attributedFullText.string)
//                    self.primaryAddressArray.append(result.attributedPrimaryText.string)
//                    self.placeIDArray.append(result.placeID)
//                }
//            }
//            self.searchResults = self.resultsArray
//            self.searhPlacesName = self.primaryAddressArray
//            self.tableView.reloadData()
//        }
//    }
    
    
}
extension SearchLocationViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForTextSearch(searchText: searchController.searchBar.text!)
    }
    
}

