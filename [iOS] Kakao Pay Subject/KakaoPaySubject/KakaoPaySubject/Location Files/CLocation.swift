//
//  location.swift
//  KakaoPaySubject
//
//  Created by 양창엽 on 11/01/2019.
//  Copyright © 2019 양창엽. All rights reserved.
//

import CoreLocation

// MARK: - Protocol
public protocol AlarmGetLocation {
    func alarmGetLocation()
}

class CLocation: NSObject {
    
    // MARK: - Typealies
    public typealias CurrentLocation = (latitude: Double, longitude: Double)
    
    // MARK: - Variables
    public var delegate:                AlarmGetLocation?
    private var currentLocation:        CurrentLocation = (0, 0)
    private var currentAddress:         String          = ""
    public static let locationInstance: CLocation = CLocation()
    private let locationManager:        CLLocationManager = CLLocationManager()
    
    // MARK: - Init
    private override init() {}
    
    // MARK: - Method
    public func settingLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.startUpdatingLocation()
    }
    public func getCurrentLocation() -> CurrentLocation {
        return self.currentLocation
    }
    public func getCurrentAddress() -> String  { return self.currentAddress }
    public func getCurrentAddress(group: DispatchGroup) {
        
        let geoCoder: CLGeocoder = CLGeocoder()
        let location: CLLocation = CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
        
        group.enter()
        DispatchQueue.global(qos: .userInitiated).async(group: group, execute: { [unowned self] in
            
            geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemark, error) -> Void in
                
                guard error == nil, let place = placemark?.first else {
                    group.leave()
                    fatalError("❌ Error, Convert GEO Location.")
                }
                
                if let administrativeArea: String = place.administrativeArea    { self.currentAddress.append(administrativeArea + " ") }
                if let locality:           String = place.locality              { self.currentAddress.append(locality + " ") }
                if let subLocality:        String = place.subLocality           { self.currentAddress.append(subLocality + " ") }
                if let subThoroughfare:    String = place.subThoroughfare       { self.currentAddress.append(subThoroughfare + " ") }
                
                group.leave()
            })
        })
    }
}

// MARK: - CLLocationManagerDelegate Extension
extension CLocation: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location: CLLocation = locations.last else {
            fatalError("❌ Error, get location from GPS.")
        }
        
        if location.horizontalAccuracy < 100 {
            self.delegate?.alarmGetLocation()
            self.currentLocation = (location.coordinate.latitude, location.coordinate.longitude)
            self.locationManager.stopUpdatingLocation()
        }
    }
    
}
