//
//  SecondViewController.swift
//  KakaoPaySubject
//
//  Created by 양창엽 on 11/01/2019.
//  Copyright © 2019 양창엽. All rights reserved.
//

import UIKit
import SwiftSpinner

class DetailViewController: UIViewController {
    
    // MARK: - Variables
    
    // MARK: - Outlet Variables
    @IBOutlet private weak var titleLB:     UILabel!
    @IBOutlet private weak var tourIMG:     UIImageView!
    @IBOutlet private weak var mapIMG:      UIImageView!
    @IBOutlet private weak var webTourTB:   UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //SwiftSpinner.show("Just a moment", animated: true)
    }
    
    // MARK: - Method
    private func showTourInformation(parameter: String) {
        
        let group: DispatchGroup = DispatchGroup()
        WebTour.webTourInstance.parserTextWebTour(group: group, query: parameter)
        
    }

    // MARK: - Action Method
    @IBAction private func closeViewController(_ sender: UIButton) {
        vibrateDevice()
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Transmit Delegate Extension
extension DetailViewController: Transmit {
    
    func transmitData(parameter: String) {
        
    }
}
