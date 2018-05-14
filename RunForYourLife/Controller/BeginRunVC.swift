//
//  BeginRunVC.swift
//  RunForYourLife
//
//  Created by Valentinas Mirosnicenko on 5/13/18.
//  Copyright © 2018 Valentinas Mirosnicenko. All rights reserved.
//

import UIKit
import MapKit
import RealmSwift

class BeginRunVC: LocationVC {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var lastRunCloseButton: UIButton!
    @IBOutlet weak var averagePaceLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var lastRunView: UIView!
    @IBOutlet weak var lastRunStack: UIStackView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationAuthStatus()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        mapView.delegate = self
        manager?.delegate = self
        manager?.startUpdatingLocation()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        setupMapView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        manager?.stopUpdatingLocation()
    }
    
    @IBAction func centerOnMapButtonPressed(_ sender: Any) {
        centerMapOnUserLocation()
    }
    
    @IBAction func lastRunCloseButtonPressed(_ sender: Any) {
        hideLastRun(show: true)
        centerMapOnUserLocation()
    }
    
    fileprivate func centerMapOnUserLocation() {
        mapView.userTrackingMode = .follow
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(mapView.userLocation.coordinate, 500, 500)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    fileprivate func centerMapOnPreviousRoute(locations: List<Location>) -> MKCoordinateRegion {
        guard let initialLocation = locations.first else { return MKCoordinateRegion() }
        var minLatitude = initialLocation.latitude
        var minLongitude = initialLocation.longitude
        var maxLatitude = minLatitude
        var maxLongitude = minLongitude
        
        for location in locations {
            minLatitude = min(minLatitude, location.latitude)
            maxLatitude = max(maxLatitude, location.latitude)
            minLongitude = min(minLongitude, location.longitude)
            maxLongitude = max(maxLongitude, location.longitude)
        }
        
        return MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: (minLatitude + maxLatitude)/2, longitude: (minLongitude + maxLongitude)/2), span: MKCoordinateSpan(latitudeDelta: (maxLatitude - minLatitude)*1.4, longitudeDelta: (maxLongitude - minLongitude)*1.4))
        
    }
    
    fileprivate func setupMapView() {
        if let overlay = addLastRunToMap() {
            if mapView.overlays.count > 0 {
                mapView.removeOverlays(mapView.overlays)
            }
            mapView.add(overlay)
            hideLastRun(show: false)
        } else {
            hideLastRun(show: true)
            centerMapOnUserLocation()
        }
    }
    
    fileprivate func addLastRunToMap() -> MKPolyline? {
        guard let lastRun = Run.getAllRuns()?.first else { return nil }
        averagePaceLabel.text = "Average pace: \(lastRun.pace.formatTimeDurationToString()) min/km"
        distanceLabel.text = "Distance: \(lastRun.distance.metersToKilometers(places: 0)) km"
        durationLabel.text = "Duration: \(lastRun.duration.formatTimeDurationToString())"
        
        var coordinates = [CLLocationCoordinate2D]()
        
        for location in lastRun.locations {
            coordinates.append(CLLocationCoordinate2D(latitude: CLLocationDegrees(location.latitude), longitude: CLLocationDegrees(location.longitude)))
        }
        
        mapView.userTrackingMode = .none
        mapView.setRegion(centerMapOnPreviousRoute(locations: lastRun.locations), animated: true)
        return MKPolyline(coordinates: coordinates, count: lastRun.locations.count)
    }
    
    fileprivate func hideLastRun(show:Bool) {
        lastRunView.isHidden = show
        lastRunStack.isHidden = show
        lastRunCloseButton.isHidden = show
    }
    
}

extension BeginRunVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            checkLocationAuthStatus()
            mapView.showsUserLocation = true
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polyline = overlay as! MKPolyline
        let renderer = MKPolylineRenderer(polyline: polyline)
        
        renderer.strokeColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)
        renderer.lineWidth = 4
        
        return renderer
    }
    
}

