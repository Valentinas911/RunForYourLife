//
//  BeginRunVC.swift
//  RunForYourLife
//
//  Created by Valentinas Mirosnicenko on 5/13/18.
//  Copyright © 2018 Valentinas Mirosnicenko. All rights reserved.
//

import UIKit
import MapKit

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
        
    }
    
    @IBAction func lastRunCloseButtonPressed(_ sender: Any) {
        hideLastRun(show: true)
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
            mapView.userTrackingMode = .follow
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

