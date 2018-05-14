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
        mapView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        manager?.delegate = self
        manager?.startUpdatingLocation()
        getLastRun()
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
    
    fileprivate func getLastRun() {
        guard let lastRun = Run.getAllRuns()?.first else {
            hideLastRun(show: true)
            return
        }
        hideLastRun(show: false)
        averagePaceLabel.text = "Average pace: \(lastRun.pace.formatTimeDurationToString()) min/km"
        distanceLabel.text = "Distance: \(lastRun.distance.metersToKilometers(places: 0)) km"
        durationLabel.text = "Duration: \(lastRun.duration.formatTimeDurationToString())"
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
    
}

