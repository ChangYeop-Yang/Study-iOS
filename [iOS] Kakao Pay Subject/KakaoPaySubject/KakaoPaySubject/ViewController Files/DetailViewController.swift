//
//  SecondViewController.swift
//  KakaoPaySubject
//
//  Created by 양창엽 on 11/01/2019.
//  Copyright © 2019 양창엽. All rights reserved.
//

import UIKit
import MapKit
import SwiftSpinner

class DetailViewController: UIViewController {
    
    // MARK: - Enum
    private enum IndexBT: Int {
        case Next       = 200
        case Privious   = 100
    }
    
    // MARK: - Variables
    private var index: Int = 0
    
    // MARK: - Outlet Variables
    @IBOutlet private weak var titleLB:     UILabel!
    @IBOutlet private weak var tourIMG:     UIImageView!
    @IBOutlet private weak var webTourTB:   UITableView!
    @IBOutlet weak var priviousBT: UIButton!
    @IBOutlet weak var nextBT: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        WebTour.webTourInstance.delegate = self
    }
    
    // MARK: - Method
    private func showTourInformation(parameter: String) {
        
        let groupWebImage: DispatchGroup = DispatchGroup()
        WebTour.webTourInstance.parserImageWebTour(group: groupWebImage, query: parameter)
        
        groupWebImage.notify(queue: .main) { [unowned self] in
            guard let imageURL = WebTour.webTourInstance.getWebImageInformation().first else {
                return
            }
            self.priviousBT.isEnabled = false
            self.tourIMG.downloadImage(link: imageURL.image)
        }
        
        let groupWebText: DispatchGroup = DispatchGroup()
        WebTour.webTourInstance.parserTextWebTour(group: groupWebText, query: parameter)
        
        groupWebText.notify(queue: .main) { [unowned self] in
            self.titleLB.text = parameter
            self.webTourTB.delegate = self
            self.webTourTB.dataSource = self
            self.webTourTB.reloadData()
            SwiftSpinner.hide()
        }
    }

    // MARK: - Action Method
    @IBAction private func closeViewController(_ sender: UIButton) {
        vibrateDevice()
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func changePhoto(_ sender: UIButton) {
        vibrateDevice()
        
        guard let indexBT: IndexBT = IndexBT(rawValue: sender.tag) else {
            return
        }
        
        let inf = WebTour.webTourInstance.getWebImageInformation()
        switch indexBT {
            case .Next:
                self.index += 1
                if inf.count < self.index { self.nextBT.isEnabled = false }
                else { self.tourIMG.downloadImage(link: inf[self.index].image); self.priviousBT.isEnabled = true; }
            case .Privious:
                self.index -= 1
                if self.index <= 0 { self.priviousBT.isEnabled = false }
                else { self.tourIMG.downloadImage(link: inf[self.index].image); self.nextBT.isEnabled = true; }
        }
    }
}

// MARK: - Transmit Delegate Extension
extension DetailViewController: Transmit {
    
    func transmitData(parameter: String) {
        showTourInformation(parameter: parameter)
    }
}

// MARK: - UITableViewDataSource Extension
extension DetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WebTour.webTourInstance.getWebTextInformation().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let inf = WebTour.webTourInstance.getWebTextInformation()
        let cell = tableView.dequeueReusableCell(withIdentifier: "WebSubCell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "WebSubCell")
    
        let data: Data = Data(inf[indexPath.row].title.utf8)
        if let attrString: NSAttributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
            cell.textLabel?.attributedText = attrString
        }
        cell.detailTextLabel?.text = inf[indexPath.row].date
        
        return cell
    }
}

extension DetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
