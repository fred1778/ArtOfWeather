//
//  LocationServices.swift
//  Weather2
//
//  Created by Fred Clamp-Gray on 05/01/2021.
//

import Foundation
import SwiftUI
import CoreLocation
import MapKit

struct locResult : Hashable{
    
    let coords : CLLocation
    
    
    let city : String
    let adminRegion : String
    // this returns state abbrvs for US or major regions e.g. England. In some countries it returns cities
    let country : String
    
    var oneLineResult : String{
        return city + ", " + adminRegion + ", " + country
    }
}




class LocSearch_two : NSObject, ObservableObject, MKLocalSearchCompleterDelegate{
    var completer = MKLocalSearchCompleter()

    @Published var comp_results = [MKLocalSearchCompletion]()
    @Published var network_error = false
    @Published var returnedPlace: MKPlacemark?
    func searchFor(_ query: String){
        
        let filter = MKPointOfInterestFilter.excludingAll
        completer.pointOfInterestFilter = filter
        
        completer.queryFragment = query
        completer.delegate = self
        
    }
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
       // print("sesrch")
        self.comp_results = completer.results
        
    }
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print(error)
        if error.localizedDescription == "The internet connection appears to be offline."{
            print("MK ERROR - offline")
            self.network_error = true
        }
    
    }
    
    func proceedOnTap(_ completedSearch: MKLocalSearchCompletion) -> MKPlacemark?{
        
        let searchReq = MKLocalSearch.Request(completion: completedSearch)
        searchReq.region = MKCoordinateRegion(.world)
        
        var place : MKPlacemark?
        let search = MKLocalSearch(request: searchReq)
        
        search.start{ response, error   in
            guard let response = response else{
                print(error.debugDescription)
            
                return 
            }
            
            let result = response.mapItems[0]
            
            
            DispatchQueue.main.async {
                
            
            
            self.returnedPlace = result.placemark
                place = result.placemark

                print("IN === \(place)")

            }
            
            
            
            
            

        
    }
        print("ppp")
        return place
        
}

}


class LocationSearcher : ObservableObject{
    
    @Published var results = [locResult]()
    @Published var networkError  = false
    
    func searchFor(_ query: String){
        var localityManifest = [String]()
        self.results = [locResult]()
    let searchRequest = MKLocalSearch.Request()
        
        let PoIFliter = MKPointOfInterestFilter.excludingAll
        searchRequest.region = MKCoordinateRegion(.world)
        searchRequest.pointOfInterestFilter = PoIFliter
        searchRequest.naturalLanguageQuery = query
        let search = MKLocalSearch(request: searchRequest)
        search.start{ response, error in
            guard let response = response else{
               // print(error.debugDescription)
                
            
                return
            }
            for item in response.mapItems{
                
                let newItem = locResult(coords: item.placemark.location!, city: item.placemark.locality ?? "n/a", adminRegion: item.placemark.administrativeArea ?? "", country: item.placemark.country ?? "N/A")
                
                
                if !localityManifest.contains(newItem.city){
                    self.results.append(newItem)
                    localityManifest.append(newItem.city)
                }
            }
            
            
        }
    
        
    }
    
}

class locationSystem : ObservableObject{
    
    @Published var location_manager = CLLocationManager()
    @Published var primaryLoc = "Current Location"
    @Published var hasGotCurrentLoc = false
    func authenticateLocation(){
        print("auth location")
        self.location_manager.requestWhenInUseAuthorization()
        
    }
}


class LocationFetcher: NSObject, CLLocationManagerDelegate, ObservableObject {
    
    let manager = CLLocationManager()
    @Published var primaryLoc : CLLocation?
    @Published var hasGotCurrentLoc = false
    @Published var locationDenied = false

    @Published var lastKnownLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)

    var key = false
    override init() {
        super.init()
        manager.delegate = self
    }
    
    
    
    
    func reAuthenticateOnRequest(){
        print("reauth request")
        
        manager.requestWhenInUseAuthorization()
            key = true
        
        
    }
    
    
    func authenticate(){
        print("checking location rights")
        
        if manager.authorizationStatus == .notDetermined{
            print("req")
        manager.requestWhenInUseAuthorization()
            key = true
        }
    }
    

    
    func  locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if key == false {

            let userSettings = UserDefaults.standard
            if userSettings.bool(forKey: "LOC_RE_AUTH"){
        print("location settings change from settings")

                
                if manager.authorizationStatus == .authorizedWhenInUse{
                    manager.requestLocation()

                    
                    let currentLoc = manager.location

                    lastKnownLocation = currentLoc!.coordinate
                    print("LNL: \(lastKnownLocation)")
                    MainCache.userLocationOnStart = currentLoc
                    self.primaryLoc = currentLoc
                    self.hasGotCurrentLoc = true
                } else if manager.authorizationStatus == .denied{
                    print("auth denied")
                    self.locationDenied = true
                }
                
                
                userSettings.setValue(false, forKey: "LOC_RE_AUTH")

                
                
                
                
                
            }
            
        }
        if key == true{
        print("location manager change delegate method called")
        if manager.authorizationStatus == .authorizedWhenInUse{
            manager.requestLocation()
            var currentLoc = CLLocation()
            if manager.location != nil{
            
                currentLoc = manager.location!
            }

            lastKnownLocation = currentLoc.coordinate
            print("LNL: \(lastKnownLocation)")
            self.primaryLoc = currentLoc
            MainCache.userLocationOnStart = currentLoc
            self.hasGotCurrentLoc = true
        } else if manager.authorizationStatus == .denied{
            print("auth denied")
            self.locationDenied = true
        }
        }
    }
    func start() {
        print("starting loc sys")
        
    //    manager.requestWhenInUseAuthorization()

        manager.requestLocation()
        
        
       if manager.authorizationStatus == .authorizedWhenInUse{
            let currentLoc = manager.location

        lastKnownLocation = currentLoc?.coordinate ?? CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
            print("LNL: \(lastKnownLocation)")
             self.primaryLoc = currentLoc
             MainCache.userLocationOnStart = currentLoc

            self.hasGotCurrentLoc = true
       } else if manager.authorizationStatus == .denied{
            print("location access refused in previous session")
        self.locationDenied = true 
       }
        
        
        
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()

        lastKnownLocation = locations.first!.coordinate
        self.primaryLoc = locations.first
        print(lastKnownLocation)
        
   
        
      //  print("location got")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    
}


extension CLLocation {
    func geocode(completion: @escaping (_ placemark: [CLPlacemark]?, _ error: Error?) -> Void)  {
        CLGeocoder().reverseGeocodeLocation(self, completionHandler: completion)
    }
}
