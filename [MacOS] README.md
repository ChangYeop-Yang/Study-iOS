# ■ Study - MacOS

## 🧐 MacOS Major Broswer (Safari, Opera, Firefox, Chrome) History Path

## 🧐 MacOS Serial Number

#### 📔 Read MacOS Serial Number Source Code

```Swift
func deviceSerialNumber() -> String? {
         
        let platformExpert = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("IOPlatformExpertDevice"))
         
        guard platformExpert > 0,
                let serial = (IORegistryEntryCreateCFProperty(platformExpert, kIOPlatformSerialNumberKey as CFString, kCFAllocatorDefault, 0).takeUnretainedValue() as? String)?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) else {
            return nil
        }
         
        IOObjectRelease(platformExpert)
         
        return serial
    }
```

## 🧐 프로퍼티 리스트 (plist, Property List)

* 프로퍼티 리스트(property list)는 OS X, iOS, NeXTSTEP, GNUstep 프로그래밍 소프트웨어 프레임워크 등에 이용되는 객체 직렬화를 위한 파일입니다. 또한 .plist라는 확장자를 가지므로, 보통 plist 파일이라고 하는 경우가 많습니다.

#### 📔 (읽기) 프로퍼티 리스트 (plist, Property List) Source Code

```Swift
func readPlist(fileName: String) -> Any? {
        
        var result: Any
        
        guard let path = Bundle.main.path(forResource: fileName, ofType: "plist"),
              let data = FileManager.default.contents(atPath: path) else {
                fatalError("Error, Read plist file.")
        }
        
        do {
            result = try PropertyListSerialization.propertyList(from: data, options: .mutableContainersAndLeaves, format: nil)
            
            // Here Processing PropertyListSerialization Data.
        } catch {
            fatalError("Error, Serialization plist file.")
        }
        
        return result
    }
    
    func readPlistByCodable(fileName: String) -> Any? {
        
        var result: Any
        
        guard let path = Bundle.main.path(forResource: fileName, ofType: "plist"),
              let data = FileManager.default.contents(atPath: path),
              let xml = FileManager.default.contents(atPath: path)  else {
                fatalError("Error, Read plist file.")
        }
        
        do {
            result = try PropertyListDecoder().decode(Property.self, from: xml)
            
            // Here Processing PropertyListSerialization Data.
        } catch {
            fatalError("Error, Serialization plist file.")
        }
        
        return result
    }
```

#### 📔 (쓰기) 프로퍼티 리스트 (plist, Property List) Write Source Code

```Swift
func writePlistByCodable(fileName: String) {
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml
        
        guard let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(fileName) else {
            fatalError("Error, Get plist file path.")
        }
        
        /// Write Plist By Codable Test Data.
        let data: Property = Property(name: "Ahn", zip: 13495)
        do {
            let data = try? encoder.encode(data)
            try data?.write(to: path)
        } catch {
            fatalError("Error, Write Serialization plist file.")
        }
    }
```
