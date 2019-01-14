//
//  Tour.swift
//  KakaoPaySubject
//
//  Created by 양창엽 on 12/01/2019.
//  Copyright © 2019 양창엽. All rights reserved.
//

import Alamofire

class Tour: NSObject {
    
    // MARK: - Enum
    private enum TourCase: String {
        case Title = "title"
        case Tel   = "tel"
        case Dist  = "dist"
        case Addr  = "addr1"
        case Image = "firstimage"
        case MapY  = "mapy"
        case MapX  = "mapx"
    }
    
    // MARK: - Structure
    public struct TourINF {
        // String
        var name:       String                      = "❌ 이름 없음"
        var address:    String                      = "❌ 주소 없음"
        var tel:        String                      = "❌ 전화번호 없음"
        var imageURL:   [String]                    = []
        var location:   (lat: String, long: String) = ("0.0", "0.0")
        
        // Integer
        var distance:   Int                         = 0
    }
    
    // MARK: - Variables
    public static let tourInstance: Tour           = Tour()
    private var tourINFList:        [TourINF]      = []
    
    // MARK: - Init
    private override init() {}
    
    // MARK: - Method
    private func extractTourInformation(parser: [String: Any]) -> TourINF {
        
        let containKeys           = parser.keys
        
        var information: TourINF = TourINF()
        for key in containKeys where containKeys.contains(key) {
            
            guard let tourKey: TourCase = TourCase(rawValue: key) else {
                continue
            }
            
            switch tourKey {
                case .Title: information.name           = parser[key] as! String
                case .Tel:   information.tel            = parser[key] as! String
                case .Dist:  information.distance       = parser[key] as! Int
                case .Addr:  information.address        = parser[key] as! String
                case .MapX:  information.location.long  = String(describing: parser[key]!)
                case .MapY:  information.location.lat   = String(describing: parser[key]!)
                case .Image: information.imageURL.append(parser[key] as! String)
            }
        }
        
        return information
    }
    public func getTourInformation() -> [TourINF] { return self.tourINFList }
    public func parserTourInformation(group: DispatchGroup, latitude: Double, longitude: Double) {
        
        group.enter()
        DispatchQueue.global(qos: .userInteractive).async(group: group) {
            
            guard let link: URL = URL(string: "http://api.visitkorea.or.kr/openapi/service/rest/KorService/locationBasedList?serviceKey=\(TOUR_API_KEY)&numOfRows=20&pageNo=1&MobileOS=ETC&MobileApp=KakaoSubject&arrange=O&contentTypeId=12&mapX=\(longitude)&mapY=\(latitude)&radius=10000&listYN=Y&_type=json") else {
                fatalError("❌ Error, could not connect server.")
            }
            
            Alamofire.request(link).responseJSON { [unowned self] response in
                
                guard response.result.isSuccess else {
                    group.leave()
                    fatalError("❌ Error, Not Receive Data From Tour API Server.")
                }
                
                switch response.response?.statusCode {
                    case .none : print("❌ Error, Not Receive Data From Tour API Server.")
                    case .some(_) :
                        
                        guard let result = response.result.value, let json = result as? NSDictionary else { return }
                        
                        guard let response   = json["response"] as? [String: Any] else { return }
                        guard let body       = response["body"] as? [String: Any] else { return }
                        guard let items      = body["items"]    as? [String: Any] else { return }
                        guard let item       = items["item"]    as? [[String: Any]] else { return }
                        
                        for information in item {
                            self.tourINFList.append( self.extractTourInformation(parser: information) )
                        }
                }
                group.leave()
                
            }
        }
    }
}
