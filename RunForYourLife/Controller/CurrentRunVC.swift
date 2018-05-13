//
//  CurrentRunVC.swift
//  RunForYourLife
//
//  Created by Valentinas Mirosnicenko on 5/13/18.
//  Copyright © 2018 Valentinas Mirosnicenko. All rights reserved.
//

import UIKit

class CurrentRunVC: LocationVC, UIGestureRecognizerDelegate {

    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var avgPaceLabel: UILabel!
    
    @IBOutlet weak var swipeBGImageView: UIImageView!
    @IBOutlet weak var sliderImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(endRunSwiped(sender:)))
        sliderImageView.addGestureRecognizer(swipeGesture)
        sliderImageView.isUserInteractionEnabled = true
        swipeGesture.delegate = self

    }
    
    
    @IBAction func pauseRunButtonPressed(_ sender: Any) {
        
    }
    
    @objc func endRunSwiped(sender: UIPanGestureRecognizer) {
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
