//
//  ConnectViewController.swift
//  KakaoPaySubject
//
//  Created by 양창엽 on 11/01/2019.
//  Copyright © 2019 양창엽. All rights reserved.
//

import UIKit
import AudioToolbox

class ConnectViewController: UIViewController {    
    
    // MARK: - Outlet Variables
    @IBOutlet weak var locationAutorityV: RoundView!
    @IBOutlet weak var outlineAppMarkV: UIView! {
        didSet {
            outlineAppMarkV.layer.borderWidth = 3
            outlineAppMarkV.layer.borderColor = UIColor.white.cgColor
        }
    }
    @IBOutlet weak var showIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Show Outline Application Mark Animation.
        showOutlineAnimation()
    }
    
    // MARK: - Method
    private func transferNextStoryBoard(name: String) {
        
        guard let nextController = UIStoryboard(name: name, bundle: nil).instantiateInitialViewController() else {
            fatalError("❌ Error, could not load UIStoryBoard.")
        }
        self.present(nextController, animated: true, completion: nil)
    }
    private func showOutlineAnimation() {
        UIView.animateKeyframes(withDuration: 0.5, delay: 0.3, options: [], animations: { [unowned self] in
            
            self.outlineAppMarkV.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 8)
            }, completion: { [unowned self] (_) in
                
                // Show Acquire Location Button.
                if !UserDefaults.standard.bool(forKey: LOCATION_ACQUIRE_KEY) {
                    self.showLocationButton()
                } else {
                    self.showIndicator.isHidden = false
                    CLocation.locationInstance.delegate = self
                    CLocation.locationInstance.settingLocationManager()
                }
        })
    }
    private func showLocationButton() {
        UIView.animate(withDuration: 0.5, delay: 0.4, options: [], animations: { [unowned self] in
            self.locationAutorityV.isHidden = false
        }, completion: nil)
    }

    // MARK: - Action Method
    @IBAction func acquireLocation(_ sender: UIButton) {
        
        self.showIndicator.isHidden         = false
        self.locationAutorityV.isHidden     = true
        
        CLocation.locationInstance.delegate = self
        CLocation.locationInstance.settingLocationManager()
    }
}

// MARK: - ConnectViewController Delegate Extenstion
extension ConnectViewController: AlarmGetLocation {
    
    func alarmGetLocation() {
        UserDefaults.standard.set(true, forKey: LOCATION_ACQUIRE_KEY)
        transferNextStoryBoard(name: "Main")
        
        let location = CLocation.locationInstance.getCurrentLocation()
        print("💬 Current Location: \(location.latitude), \(location.longitude)")
    }
}
