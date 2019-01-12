//
//  FirstViewController.swift
//  KakaoPaySubject
//
//  Created by 양창엽 on 11/01/2019.
//  Copyright © 2019 양창엽. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - Outlet Variables
    @IBOutlet weak var wallPaperIMG:        UIImageView!
    @IBOutlet weak var weatherLogoIMG:      CircleImageView!
    @IBOutlet weak var weatherStateLB:      UILabel!
    @IBOutlet weak var visualityStateLB:    UILabel!
    @IBOutlet weak var humidityStateLB:     UILabel!
    @IBOutlet weak var dustStateLB:         UILabel!
    @IBOutlet weak var addressLB:           UILabel!
    @IBOutlet weak var tourListCV:          UICollectionView!
    @IBOutlet weak var homeTabTBI:          UITabBarItem!
    @IBOutlet weak var emptyV:              UIView!
    
    // MARK: - Variables
    private let CELL_NAME: String           = "DetailCell"
    private var currentLocation             = CLocation.locationInstance.getCurrentLocation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showCurrentAddress()
        showWeatherInformation()
        showCurrentTourList()
    }

    // MARK: - Method
    private func showWeatherInformation() {
        
        let group: DispatchGroup = DispatchGroup()
        
        Weather.weatherInstance.receiveWeatherData(group: group, language: "ko", latitude: self.currentLocation.latitude, longtitude: self.currentLocation.longitude)
        
        group.notify(queue: .main, execute: { [unowned self] in
            
            let weatherINF = Weather.weatherInstance.getWeatherInformation()
            
            // Lable
            self.weatherStateLB.text    = weatherINF.sky
            self.humidityStateLB.text   = "💧 \(weatherINF.humidity * 100) %"
            self.visualityStateLB.text  = "🌈 \(weatherINF.visibility) KM"
            
            // Image View
            self.weatherLogoIMG.image   = UIImage(named: weatherINF.icon)
        })
    }
    private func showDustInformation() {
        
        guard let adminArea = CLocation.locationInstance.getCurrentAddress().split(separator: " ").first else {
            fatalError("❌ Error, could not get current address.")
        }
        
        let group: DispatchGroup = DispatchGroup()
        Dust.dustInstance.receiveDustData(adminArea: String(adminArea), group: group)
        
        group.notify(queue: .main, execute: { [unowned self] in
            let dustINF             = Dust.dustInstance.getDustReuslt()
            self.dustStateLB.text   = "💨 \(dustINF) ㎍/㎥"
        })
    }
    private func showCurrentAddress() {
        
        let group: DispatchGroup = DispatchGroup()
        CLocation.locationInstance.getCurrentAddress(group: group)
        
        group.notify(queue: .main, execute: { [unowned self] in
            self.showDustInformation()
            self.addressLB.text     = CLocation.locationInstance.getCurrentAddress()
        })
        
    }
    private func showCurrentTourList() {
        
        let cellNib:    UINib = UINib(nibName: "DetailCell", bundle: nil)
        tourListCV.register(cellNib, forCellWithReuseIdentifier: "DetailCell")
        
        let group:      DispatchGroup             = DispatchGroup()
        let location:   CLocation.CurrentLocation = CLocation.locationInstance.getCurrentLocation()
        
        Tour.tourInstance.parserTourInformation(group: group, latitude: location.latitude, longitude: location.longitude)
        
        group.notify(queue: .main) { [unowned self] in
            self.tourListCV.dataSource   = self
            self.homeTabTBI.badgeValue   = "\(Tour.tourInstance.getTourInformation().count)"
        }
    }
}

// MARK: - UICollectionViewDataSource Extension
extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count: Int = Tour.tourInstance.getTourInformation().count
        self.emptyV.isHidden = count <= 0 ? false : true
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: DetailCell = self.tourListCV.dequeueReusableCell(withReuseIdentifier: CELL_NAME, for: indexPath) as! DetailCell
                
        let inf = Tour.tourInstance.getTourInformation()[indexPath.row]
        if let image: String = inf.imageURL.first {
            cell.settingTourInformation(name: inf.name, summary: inf.address, keyword: inf.tel, image: image)
        }
        
        return cell
    }
}
