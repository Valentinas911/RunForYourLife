//
//  CurrentRunVC.swift
//  RunForYourLife
//
//  Created by Valentinas Mirosnicenko on 5/13/18.
//  Copyright © 2018 Valentinas Mirosnicenko. All rights reserved.
//

import UIKit
import MapKit

class CurrentRunVC: LocationVC, UIGestureRecognizerDelegate {

    @IBOutlet private weak var distanceLabel: UILabel!
    @IBOutlet private weak var durationLabel: UILabel!
    @IBOutlet private weak var avgPaceLabel: UILabel!
    
    @IBOutlet private weak var swipeBGImageView: UIImageView!
    @IBOutlet private weak var sliderImageView: UIImageView!
    
    private var startLocation: CLLocation!
    private var lastLocation: CLLocation!
    private var runDiscane = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationAuthStatus()
        addPanGesture()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        manager?.delegate = self
        manager?.distanceFilter = 10
        startRun()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        manager?.stopUpdatingLocation()
    }
    
    
    @IBAction fileprivate func pauseRunButtonPressed(_ sender: Any) {
        
    }
    
    fileprivate func startRun() {
        manager?.startUpdatingLocation()
    }
    
    fileprivate func endRun() {
        manager?.stopUpdatingLocation()
    }
    
    fileprivate func addPanGesture() {
        let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(endRunSwiped(sender:)))
        sliderImageView.addGestureRecognizer(swipeGesture)
        sliderImageView.isUserInteractionEnabled = true
        swipeGesture.delegate = self
    }
    
    @objc fileprivate func endRunSwiped(sender: UIPanGestureRecognizer) {
        let minAdjust: CGFloat = 60
        
        let maxAdjust: CGFloat = 100
        
        if let sliderView = sender.view {
            if sender.state == UIGestureRecognizerState.began || sender.state == UIGestureRecognizerState.changed {
                
                let translation = sender.translation(in: self.view)
                
                if sliderView.center.x >= (swipeBGImageView.center.x - minAdjust) && sliderView.center.x <= (swipeBGImageView.center.x + maxAdjust) {
                    sliderView.center = CGPoint(x: sliderView.center.x + translation.x, y: sliderView.center.y)
                } else if sliderView.center.x >= (swipeBGImageView.center.x + maxAdjust) {
                    sliderView.center.x = (swipeBGImageView.center.x + maxAdjust)
                    
                    // End run
                    
                    dismiss(animated: true, completion: nil)
                    
                } else if sliderView.center.x <= (swipeBGImageView.center.x - minAdjust) {
                    sliderView.center.x = (swipeBGImageView.center.x - minAdjust)
                }
                
                sender.setTranslation(CGPoint.zero, in: self.view)
                
                
            } else if sender.state == UIGestureRecognizerState.ended {
                UIView.animate(withDuration: 0.15) {
                    sliderView.center.x = self.swipeBGImageView.center.x - minAdjust
                }
            }
        }
    }
    
    
}

extension CurrentRunVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            checkLocationAuthStatus()

        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if startLocation == nil {
            startLocation = locations.first
        } else if let location = locations.last {
            runDiscane += lastLocation.distance(from: location)
            distanceLabel.text = "\(runDiscane.metersToKilometers(places: 2))"
        }
        
        lastLocation = locations.last
        
    }
    
}
