//
//  WebTour.swift
//  KakaoPaySubject
//
//  Created by 양창엽 on 13/01/2019.
//  Copyright © 2019 양창엽. All rights reserved.
//

import Alamofire

class WebTour: NSObject {
    
    // MARK: - Enum
    private enum WebKey: String {
        case DateTime = "datetime"
        case Contents = "contents"
        case Title    = "title"
        case Url      = "url"
        case ImageUrl = "image_url"
        case Display  = "display_sitename"
    }
    
    // MARK: - Struct
    public struct WebTextINF {
        var title:      String = "❌ 제목 없음"
        var content:    String = "❌ 내용 없음"
        var url:        String = ""
        var date:       String = ""
    }
    public struct WebImageINF {
        var image:      String = ""
        var display:    String = "❌ 출처 없음"
    }
    
    // MARK: - Variables
    private let header = ["Authorization": "KakaoAK \(KAKAO_SEARCH_API_KEY)"]
    private var webTextInformationList:     [WebTextINF]    = []
    private var webImageInformationList:    [WebImageINF]   = []
    public static let webTourInstance:      WebTour         = WebTour()
    
    // MARK: - Init
    private override init() {}
    
    // MARK: - Method
    public func getWebTextInformation() -> [WebTextINF] { return self.webTextInformationList }
    public func getWebImageInformation() -> [WebImageINF] { return self.webImageInformationList }
    private func extractWebTourInformation(item: [String: Any], type: Bool) -> Any {
        
        var webTextInf: WebTextINF = WebTextINF()
        var webImageInf: WebImageINF = WebImageINF()
        
        let keys = item.keys
        for inf in item where keys.contains(inf.key) {
            
            guard let keyCase: WebKey = WebKey(rawValue: inf.key) else {
                continue
            }
            
            switch keyCase {
                case .DateTime: webTextInf.date     = inf.value as! String
                case .Contents: webTextInf.content  = inf.value as! String
                case .Title:    webTextInf.title    = inf.value as! String
                case .Url:      webTextInf.url      = inf.value as! String
                case .ImageUrl: webImageInf.image   = inf.value as! String
                case .Display:  webImageInf.display = inf.value as! String
            }
        }
        
        return type ? webTextInf : webImageInf
    }
    public func parserTextWebTour(group: DispatchGroup, query: String) {
        
        group.enter()
        Alamofire.request("https://dapi.kakao.com/v2/search/web", method: .get, parameters: ["query": query], encoding: URLEncoding.default, headers: header).responseJSON { [unowned self] response in
            
            guard response.result.isSuccess else {
                group.leave()
                fatalError("❌ Error, Not Receive Data From Kakao API Server.")
            }
            
            switch response.response?.statusCode {
                case .none :
                    group.leave()
                    print("❌ Error, Not Receive Data From Kakao API Server.")
                
                case .some(_) :
                    
                    guard let result = response.result.value, let json = result as? NSDictionary else { return }
                    
                    guard let documents   = json["documents"] as? [[String: Any]] else { return }
                    
                    for item in documents {
                        guard let inf: WebTextINF = self.extractWebTourInformation(item: item, type: true) as? WebTextINF else {
                            continue
                        }
                        self.webTextInformationList.append(inf)
                    }
                    
                    group.leave()
            }
            
        }
        
    }
    public func parserImageWebTour(group: DispatchGroup, query: String) {
        
        group.enter()
        
        Alamofire.request("https://dapi.kakao.com/v2/search/image", method: .get, parameters: ["query": query], encoding: URLEncoding.default, headers: header).responseJSON { [unowned self] response in
            
            guard response.result.isSuccess else {
                group.leave()
                fatalError("❌ Error, Not Receive Data From Kakao Image API Server.")
            }
            
            switch response.response?.statusCode {
                
                case .none :
                    group.leave()
                    print("❌ Error, Not Receive Data From Kakao API Server.")
                case .some(_) :
                    
                    guard let result = response.result.value, let json = result as? NSDictionary else { return }
                    
                    guard let documents   = json["documents"] as? [[String: Any]] else { return }
                    
                    for item in documents {
                        guard let inf: WebImageINF = self.extractWebTourInformation(item: item, type: false) as? WebImageINF else {
                            continue
                        }
                        self.webImageInformationList.append(inf)
                    }
                    
                    group.leave()
            }
            
        }
    }
}
