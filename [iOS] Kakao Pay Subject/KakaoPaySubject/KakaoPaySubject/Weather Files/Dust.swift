//
//  Dust.swift
//  LazyHUE
//
//  Created by 양창엽 on 2018. 8. 11..
//  Copyright © 2018년 양창엽. All rights reserved.
//

import Alamofire

// MARK: Enum
private enum AdministrativeArea: String {
    
    case 대구광역시 = "대구광역시"
    case 부산광역시 = "부산광역시"
    case 서울특별시 = "서울특별시"
    case 인천광역시 = "인천광역시"
    case 광주광역시 = "광주광역시"
    case 대전광역시 = "대전광역시"
    case 울산광역시 = "울산광역시"
    case 경기도 = "경기도"
    case 강원도 = "강원도"
    case 충청북도 = "충청북도"
    case 충청남도 = "충청남도"
    case 전라북도 = "전라북도"
    case 전라남도 = "전라남도"
    case 경상북도 = "경상북도"
    case 경상남도 = "경상남도"
    case 제주특별자치도 = "제주특별자치도"
    case 세종특별자치시 = "세종특별자치시"
    
    func getEnglishAdminArea() -> String {
        switch self {
        case .대구광역시:        return "daegu"
        case .부산광역시:        return "busan"
        case .서울특별시:        return "seoul"
        case .인천광역시:        return "incheon"
        case .광주광역시:        return "gwangju"
        case .대전광역시:        return "daejeon"
        case .울산광역시:        return "ulsan"
        case .경기도:          return "gyeonggi"
        case .강원도:          return "gangwon"
        case .충청북도:         return "chungbuk"
        case .충청남도:         return "chungnam"
        case .전라북도:         return "jeonbuk"
        case .전라남도:         return "jeonnam"
        case .경상북도:         return "gyeongbuk"
        case .경상남도:         return "gyeongnam"
        case .제주특별자치도:     return "jeju"
        case .세종특별자치시:     return "sejong"
        }
    }
}

public class Dust: NSObject {
    
    // MARK: - Variables
    private var result: String = ""
    public static let dustInstance: Dust = Dust()
    
    // MAKR: - Init
    private override init() {}
    
    // MARK: - Method
    public func getDustReuslt() -> String { return self.result }
    public func receiveDustData(adminArea: String, group: DispatchGroup) {
        
        guard let link: URL = URL(string: "http://openapi.airkorea.or.kr/openapi/services/rest/ArpltnInforInqireSvc/getCtprvnMesureLIst?serviceKey=\(DUST_OPEN_API_KEY)&numOfRows=10&pageSize=10&pageNo=1&startPage=1&itemCode=PM10&dataGubun=HOUR&searchCondition=MONTH(&_returnType=json") else {
            fatalError("❌ Error, Not Vaild URL.")
        }
        
        DispatchQueue.global(qos: .userInitiated).async(group: group, execute: { [unowned self] in
            
            group.enter()
                
            Alamofire.request(link).responseJSON(completionHandler: { response in
                
                guard response.result.isSuccess else {
                    group.leave()
                    return
                }
                
                switch (response.response?.statusCode) {
                    
                    case .none:
                        group.leave()
                        print("❌ Error, Not Receive Data From Korea Meteorological Administration Server.")
                    
                    case .some(_):
                            guard let result = response.result.value, let json = result as? NSDictionary else { return }
                            guard let list = json["list"] as? [[String:Any]] else { return }
                            
                            if let item: [String:Any] = list.first, let administrativeArea: AdministrativeArea = AdministrativeArea(rawValue: adminArea) {
                                
                                if let currentDust: String = item[administrativeArea.getEnglishAdminArea()] as? String {
                                    self.result = currentDust
                                    print("- Fine Dust: \(currentDust) ㎍/㎥")
                                }
                            
                            }
                            
                            group.leave()
                    }
            })
        })
    }
}
