# ■ 2019 Kakao Pay Client 사전과제 <kbd>**MOBILE - iOS**</kbd>

:floppy_disk: [Download - 2019 Kakao Pay Client Zip File](https://github.com/ChangYeop-Yang/Study-iOS/files/2754882/iOS.Kakao.Pay.Subject.zip)

* Simulator를 통하여 Application을 실행하시는 경우에는 **국내 임의 좌표 (Example: 37.394063, 127.110112)** 을 이용해주시고 **Simulator Device 언어 환경은 한국어**로 변경 후 실행시켜주세요 :exclamation::exclamation::exclamation: 

## ★ Application Development Environment

:wrench: iOS Version 12.1.2 (iPhone 6)

:wrench: Simulator Version 10.1 (iPhone XS)

:wrench: macOS Mojave Version 10.14.2

:wrench: GitHub Desktop Version 1.4.3 

:wrench: Xcode  Version 10.1 (10B61)

:wrench: Apple Swift version 4.2.1 (swiftlang-1000.11.42 clang-1000.11.45.1)

## ★ Application UI/UX Layer

|:straight_ruler: Home Display Layer|:straight_ruler: Home Display Layer|
|:---------------------------------:|:---------------------------------:|
|![](https://user-images.githubusercontent.com/20036523/51105630-def90480-182c-11e9-895d-33e88b1951ec.png)|![](https://user-images.githubusercontent.com/20036523/51105628-def90480-182c-11e9-9bee-e576e592e0a4.png)|

|:straight_ruler: Detail Display Layer|:straight_ruler: Detail Display Layer|
|:-----------------------------------:|:-----------------------------------:|
|![](https://user-images.githubusercontent.com/20036523/51105622-ddc7d780-182c-11e9-92c2-f6dde5beee85.png)|![](https://user-images.githubusercontent.com/20036523/51105623-de606e00-182c-11e9-8c6d-7a5f42041abd.png)|

## ★ Application UI/UX

|:camera: HOME Display|:camera: HOME Display|
|:-------------------:|:-------------------:|
|![](https://user-images.githubusercontent.com/20036523/51105624-de606e00-182c-11e9-9b29-9635e0702b0d.png)|![](https://user-images.githubusercontent.com/20036523/51105627-def90480-182c-11e9-84dd-4caa8b0a0c50.png)|

|:camera: DETAIL Display|:camera: SETTING Display|
|:---------------------:|:----------------------:|
|![](https://user-images.githubusercontent.com/20036523/51105625-de606e00-182c-11e9-9644-102ce4a4e8a4.png)|![](https://user-images.githubusercontent.com/20036523/51105626-def90480-182c-11e9-8b6d-807f30a0e8be.png)|

|:mag_right: HOME Display|
|:----------------------:|
|![](https://user-images.githubusercontent.com/20036523/51111363-32744e00-183f-11e9-8b86-78e97382e6c2.JPG)|

|:mag_right: DETAIL Display|
|:------------------------:|
|![](https://user-images.githubusercontent.com/20036523/51111364-32744e00-183f-11e9-94b9-3a6c3e608c3b.JPG)|

## ★ Application Source Code

##### ※ Public Information REST API Source Code
```swift
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
```

##### ※ Kakao Search Platform REST API Source Code

```swift
// MARK: - Enum
private enum WebKey: String {
     case DateTime = "datetime"
     case Contents = "contents"
     case Title    = "title"
     case Url      = "url"
     case ImageUrl = "image_url"
     case Display  = "display_sitename"
}

public func parserImageWebTour(group: DispatchGroup, query: String) {
        
        group.enter()
        self.webImageInformationList.removeAll()
        
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
```

## ★ Demo Play for Application

|:movie_camera: Demo Play for Application|
|:--------------------------------------:|
|<div align="center"><a href="https://www.youtube.com/watch?v=rCy5HsZi2hs"><img src="https://img.youtube.com/vi/rCy5HsZi2hs/0.jpg" width="1024" height="486"></a></div>|

## ★ OPEN SOURCE LIST

:helicopter: [Alamofire - GitHub **(Open Source API)**](https://github.com/Alamofire/Alamofire)

* Alamfire를 사용 한 이유는 HTTP 통신을 위해서는 복잡한 구조의 URLSession을 사용하여야 합니다. 그렇기에 HTTP 통신을 단순하게 구현 한 Alamofire를 사용함으로써 개발 기간과 유지보수 측면을 강화하기 위해서 해당 오픈소스를 사용하게 되었습니다.

:helicopter: [SwiftSpinner - GitHub **(Open Source API)**](https://github.com/icanzilb/SwiftSpinner)

## ★ REFERENCE

:airplane: [카카오 검색 플랫폼 API - KakaoDevlopers **(REST API)**](https://developers.kakao.com/features/platform#%EA%B2%80%EC%83%89)

:airplane: [동네예보정보조회서비스 - 공공데이터포털 **(REST API)**](https://www.data.go.kr/dataset/15000099/openapi.do)

:airplane: [국내 관광정보 서비스 - 공공데이터포털 **(REST API)**](https://www.data.go.kr/dataset/15000496/openapi.do?mypageFlag=Y)

:airplane: [한국 환경 공단 대기오염정보 - 공공데이터포털 **(REST API)**](https://www.data.go.kr/dataset/15000581/openapi.do)

## ★ Developer Information

|:rocket: Github QR Code|:pencil: Naver-Blog QR Code|:eyeglasses: Linked-In QR Code|
|:---------------------:|:-------------------------:|:----------------------------:|
|![](https://user-images.githubusercontent.com/20036523/50044128-60406880-00c2-11e9-8d57-ea1cb8e6b2a7.jpg)|![](https://user-images.githubusercontent.com/20036523/50044131-60d8ff00-00c2-11e9-818c-cf5ad97dc76e.jpg)|![](https://user-images.githubusercontent.com/20036523/50044130-60d8ff00-00c2-11e9-991a-107bffa2bf57.jpg)|
