# ■ Study-iOS

* iOS (formerly iPhone OS) is a mobile operating system created and developed by Apple Inc. exclusively for its hardware. It is the operating system that presently powers many of the company's mobile devices, including the iPhone, iPad, and iPod Touch. It is the second most popular mobile operating system globally after Android.

## ★ Automatic Reference Counting (ARC)

|:camera: ARC Image 001|:camera: ARC Image 002|
|:--------------------:|:--------------------:|
|![](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/MemoryMgmt/Art/memory_management_2x.png)|![](https://developer.apple.com/library/archive/releasenotes/ObjectiveC/RN-TransitioningToARC/Art/ARC_Illustration.jpg)|

* Automatic Reference Counting (ARC) is a memory management feature of the Clang compiler providing automatic reference counting for the Objective-C and Swift programming languages. **At compile time, it inserts into the object code messages retain and release which increase and decrease the reference count at run time, marking for deallocation those objects when the number of references to them reaches zero.**
</br></br> ARC differs from tracing garbage collection in that there is no background process that deallocates the objects asynchronously at runtime. Unlike garbage collection, ARC does not handle reference cycles automatically. This means that as long as there are "strong" references to an object, it will not be deallocated. **Strong cross-references can accordingly create deadlocks and memory leaks. It is up to the developer to break cycles by using weak references.**

```Swift
/* How do I create a deadlock in Grand Central Dispatch?
https://stackoverflow.com/questions/15381209/how-do-i-create-a-deadlock-in-grand-central-dispatch */

dispatch_queue_t queue = dispatch_queue_create("my.label", DISPATCH_QUEUE_SERIAL);
dispatch_async(queue, ^{
    dispatch_sync(queue, ^{
        // outer block is waiting for this inner block to complete,
        // inner block won't start before outer block finishes
        // => deadlock
    });

    // this will never be reached
}); 
```

* Apple Inc. deploys ARC in their operating systems, such as macOS (OS X) and iOS. Limited support (ARCLite) has been available since Mac OS X Snow Leopard and iOS 4, with complete support following in Mac OS X Lion and iOS 5. Garbage collection was declared deprecated in OS X Mountain Lion, in favor of ARC, and removed from the Objective-C runtime library in macOS Sierra.

* * *

#### ※ Automatic Reference Counting - Swift

* In Swift, references to objects are strong, unless they are declared weak or unowned. Swift requires explicit handling of nil with the Optional type: a value type that can either have a value or be nil. An Optional type must be handled by "unwrapping" it with a conditional statement, allowing safe usage of the value, if present. Conversely, any non-Optional type will always have a value and cannot be nil. </br></br> Accordingly, a strong reference to an object cannot be of type Optional, as the object will be kept in the heap until the reference itself is deallocated. A weak reference is of type Optional, as the object can be deallocated and the reference be set to nil. Unowned references fall in-between; they are neither strong nor of type Optional. Instead, the compiler assumes that the object to which an unowned reference points is not deallocated as long the reference itself remains allocated. This is typically used in situations where the target object itself holds a reference to the object that holds the unowned reference. </br></br> Swift also differs from Objective-C in its usage and encouragement of value types instead of reference types. Most types in the Swift standard library are value types and they are copied by reference, whereas classes and closures are reference types and passed by reference. Because value types are copied when passed around, they are deallocated automatically with the reference that created them.

```swift
var myString: String                   // Can only be a string
var myOtherString: String?             // Can be a string or nil

if let myString = myOtherString {      // Unwrap the Optional
    print(myString)                    // Print the string, if present 
}

var strongReference: MyClass          // Strong reference, cannot be nil
weak var weakReference: MyClass?      // Weak reference, can be nil
unowned var unownedReference: MyClass // Weak reference, cannot be nil
```

## ★ iOS Application Life Cycle

* UIKit apps are always in one of five states, which are shown in Figure 1. Apps start off not running. When the user explicitly launches the app, the app moves briefly to the inactive state before entering the active state. (An active app appears onscreen and is known as a foreground app.) Quitting an active app moves it offscreen and into the background state, where it stays until the system suspends it a short time later. At its discretion, the system may quietly terminate a suspended app, returning it to the not running state.

* Your app’s current state defines what system resources are available to it. Because active apps are visible onscreen and must respond to user interactions, they have priority when it comes to using system resources. Background apps are not visible onscreen, and therefore have more limited access to system resources and receive limited execution time.

* * *

#### # Manage Life Cycle Events

* **Launch.** </br>Your app transitions from the not running to the inactive or background state. Use this transition to prepare your app to run.

* **Activation.** </br>Your app transitions from the inactive to the active state. Prepare your app to run in the foreground and be visible onscreen.

* **Deactivation.** </br>Your app transitions from the active to the inactive state. Quiet your app, perhaps only temporarily.

* **Background execution.** </br>Your app transitions from the inactive or not running state to the background state. Prepare to handle only essential tasks while running offscreen.

* **Termination.** </br>Your app transitions from any running state to the not running state. (Suspended apps are not notified when they are terminated.) Cancel all tasks and prepare to exit.

* * *

#### # Manage Behavioral Events

* **Memory warnings.** </br>Reduce the amount of memory your app uses; see Responding to Memory Warnings.

* **Time changes.** </br>Update time-sensitive features of your app.

* **Protected data becomes available/unavailable.** </br>Manage files when the user locks or unlocks the device.

* **State restoration.** </br>Restore your app’s UI to its previous state, giving the appearance that your app never stopped running.

* **Handoff tasks.** </br>Continue tasks started on another device.

* **Open URLs.** </br>Receive and open URLs sent to your app.

* **Inter-app communication.** </br>Receive data from a paired watchOS app.

* **File downloads.** </br>Receive files that your app downloaded using a URLSession object.

* * *

<p align="center">
  <img src="https://docs-assets.developer.apple.com/published/c63cd35863/4d403429-fa30-4706-863f-5e3617ee21d0.png" width="350" height="350" />
</p>

* Not Running - Either the application has not started yet or was running and has been terminated by the system.

* Inactive - An application is running in the Foreground but is not receiving any events. This could happen in case a Call or Message is received. An application could also stay in this state while in transition to a different state. In this State, we can not interact with app’s UI.

* Active - An application is running in the Foreground and receiving the events. This is the normal mode for the Foreground apps. The only way to go to or from the Active state is through the Inactive state. User normally interacts with UI, and can see the response/result for user actions.

* Background - An application is running in the background and executing the code. Freshly launching apps directly enter into In-Active state and then to Active state. Apps that are suspended, will come back to this background state, and then transition to In-Active → Active states. In addition, an application being launched directly into the background enters this state instead of the inactive state.

* Suspended - An application is in the background but is not executing the code. The system moves the application to this state automatically and does not notify. In case of low memory, the system may purge suspended application without notice to make free space for the foreground application. Usually after 5 secs spent in the background, apps will transition to Suspend state, but we can extend the time if app needs.

* * *

#### # App Delegate Method

* application:willFinishLaunchingWithOptions:</br>
This method is your app’s first chance to execute code at launch time.

* application:didFinishLaunchingWithOptions:</br>
This method allows you to perform any final initialization before your app is displayed to the user.

* applicationDidBecomeActive:</br>
Lets your app know that it is about to become the foreground app. Use this method for any last minute preparation.

* applicationWillResignActive:</br>
Lets you know that your app is transitioning away from being the foreground app. Use this method to put your app into a quiescent state.

* applicationDidEnterBackground:</br>
Lets you know that your app is now running in the background and may be suspended at any time.

* applicationWillEnterForeground:</br>
Lets you know that your app is moving out of the background and back into the foreground, but that it is not yet active.

* applicationWillTerminate:</br>
Lets you know that your app is being terminated. This method is not called if your app is suspended.

## ★ ViewController Life Cycle

<p align="center">
  <img src="https://developer.apple.com/library/archive/referencelibrary/GettingStarted/DevelopiOSAppsSwift/Art/WWVC_vclife_2x.png" width="350" height="350" />
</p>

* **viewDidLoad**</br>
**Called when the view controller’s content view (the top of its view hierarchy) is created and loaded from a storyboard.** The view controller’s outlets are guaranteed to have valid values by the time this method is called. Use this method to perform any additional setup required by your view controller.
</br></br>**Typically, iOS calls viewDidLoad() only once, when its content view is first created;** however, the content view is not necessarily created when the controller is first instantiated. Instead, it is lazily created the first time the system or any code accesses the controller’s view property.

* * *

* **viewWillAppear**</br>
**Called just before the view controller’s content view is added to the app’s view hierarchy.** Use this method to trigger any operations that need to occur before the content view is presented onscreen. Despite the name, just because the system calls this method, it does not guarantee that the content view will become visible. The view may be obscured by other views or hidden. This method simply indicates that the content view is about to be added to the app’s view hierarchy.

* * *

* **viewDidAppear**</br>
**Called just after the view controller’s content view has been added to the app’s view hierarchy.** Use this method to trigger any operations that need to occur as soon as the view is presented onscreen, such as fetching data or showing an animation. Despite the name, just because the system calls this method, it does not guarantee that the content view is visible. The view may be obscured by other views or hidden. This method simply indicates that the content view has been added to the app’s view hierarchy.

* * *

* **viewDidLayoutSubviews**</br>
**Called to notify the view controller that its view has just laid out its subviews.** When the bounds change for a view controller's view, the view adjusts the positions of its subviews and then the system calls this method. However, this method being called does not indicate that the individual layouts of the view's subviews have been adjusted. Each subview is responsible for adjusting its own layout.
</br></br>Your view controller can override this method to make changes after the view lays out its subviews. The default implementation of this method does nothing.

* * *

* **viewWillLayoutSubviews**</br>
Called to notify the view controller that its view is about to layout its subviews. When a view's bounds change, the view adjusts the position of its subviews. Your view controller can override this method to make changes before the view lays out its subviews. The default implementation of this method does nothing.

* * *

* **viewWillDisappear**</br>
**Called just before the view controller’s content view is removed from the app’s view hierarchy.** Use this method to perform cleanup tasks like committing changes or resigning the first responder status. Despite the name, the system does not call this method just because the content view will be hidden or obscured. This method is only called when the content view is about to be removed from the app’s view hierarchy.

* * *

* **viewDidDisappear**</br>
**Called just after the view controller’s content view has been removed from the app’s view hierarchy.** Use this method to perform additional teardown activities. Despite the name, the system does not call this method just because the content view has become hidden or obscured. This method is only called when the content view has been removed from the app’s view hierarchy.

## ★ UIKit

#### # UITableView

* A table view displays a list of items in a single column. UITableView is a subclass of UIScrollView, which allows users to scroll through the table, although UITableView allows vertical scrolling only. The cells comprising the individual items of the table are UITableViewCell objects; UITableView uses these objects to draw the visible rows of the table. Cells have content—titles and images—and can have, near the right edge, accessory views. Standard accessory views are disclosure indicators or detail disclosure buttons; the former leads to the next level in a data hierarchy and the latter leads to a detailed view of a selected item. Accessory views can also be framework controls, such as switches and sliders, or can be custom views. Table views can enter an editing mode where users can insert, delete, and reorder rows of the table.

###### ※ UITableViewDataSource

* The object that acts as the data source of the table view. 

* The data source must adopt the UITableViewDataSource protocol. The data source is not retained.

```swift
 @required 
 // 특정 위치에 표시할 셀을 요청하는 메서드
 func tableView(UITableView, cellForRowAt: IndexPath) 
 
 // 각 섹션에 표시할 행의 개수를 묻는 메서드
 func tableView(UITableView, numberOfRowsInSection: Int)
 
 @optional
 // 테이블뷰의 총 섹션 개수를 묻는 메서드
 func numberOfSections(in: UITableView)
 
 // 특정 섹션의 헤더 혹은 푸터 타이틀을 묻는 메서드
 func tableView(UITableView, titleForHeaderInSection: Int)
 func tableView(UITableView, titleForFooterInSection: Int)
 
 // 특정 위치의 행을 삭제 또는 추가 요청하는 메서드
 func tableView(UITableView, commit: UITableViewCellEditingStyle, forRowAt: IndexPath)
 
 // 특정 위치의 행이 편집 가능한지 묻는 메서드
 func tableView(UITableView, canEditRowAt: IndexPath)

 // 특정 위치의 행을 재정렬 할 수 있는지 묻는 메서드
 func tableView(UITableView, canMoveRowAt: IndexPath)
 
 // 특정 위치의 행을 다른 위치로 옮기는 메서드
 func tableView(UITableView, moveRowAt: IndexPath, to: IndexPath)
```

###### ※ UITableViewDelegate

* The object that acts as the delegate of the table view.

* The delegate must adopt the UITableViewDelegate protocol. The delegate is not retained.

```swift
 // 특정 위치 행의 높이를 묻는 메서드
 func tableView(UITableView, heightForRowAt: IndexPath)
 // 특정 위치 행의 들여쓰기 수준을 묻는 메서드
 func tableView(UITableView, indentationLevelForRowAt: IndexPath)

 // 지정된 행이 선택되었음을 알리는 메서드
 func tableView(UITableView, didSelectRowAt: IndexPath)

 // 지정된 행의 선택이 해제되었음을 알리는 메서드
 func tableView(UITableView, didDeselectRowAt: IndexPath)

 // 특정 섹션의 헤더뷰 또는 푸터뷰를 요청하는 메서드
 func tableView(UITableView, viewForHeaderInSection: Int)
 func tableView(UITableView, viewForFooterInSection: Int)

 // 특정 섹션의 헤더뷰 또는 푸터뷰의 높이를 물어보는 메서드
 func tableView(UITableView, heightForHeaderInSection: Int)
 func tableView(UITableView, heightForFooterInSection: Int)

 // 테이블뷰가 편집모드에 들어갔음을 알리는 메서드
 func tableView(UITableView, willBeginEditingRowAt: IndexPath)

 // 테이블뷰가 편집모드에서 빠져나왔음을 알리는 메서드
 func tableView(UITableView, didEndEditingRowAt: IndexPath?)
```

## ★ CORE ML

* Core ML is the foundation for domain-specific frameworks and functionality. Core ML supports Vision for image analysis, Natural Language for natural language processing, and GameplayKit for evaluating learned decision trees. Core ML itself builds on top of low-level primitives like Accelerate and BNNS, as well as Metal Performance Shaders.

* Core ML is optimized for on-device performance, which minimizes memory footprint and power consumption. Running strictly on the device ensures the privacy of user data and guarantees that your app remains functional and responsive when a network connection is unavailable.

|:camera: Core ML Image 001|:camera: Core ML Image 002|
|:------------------------:|:------------------------:|
|![](https://docs-assets.developer.apple.com/published/7e05fb5a2e/4b0ecf58-a51a-4bfa-a361-eb77e59ed76e.png)|![](https://docs-assets.developer.apple.com/published/479d7b4500/0c857af6-45e4-4fac-ad84-4aeb8c01b5a3.png)|

## 📣 [Operation Queue vs Dispatch Queue for iOS Application](https://stackoverflow.com/questions/7078658/operation-queue-vs-dispatch-queue-for-ios-application)

* NSOperationQueue predates Grand Central Dispatch and on iOS it doesn't use GCD to execute operations (this is different on Mac OS X). It uses regular background threads which have a little more overhead than GCD dispatch queues. </br></br>On the other hand, NSOperationQueue gives you a lot more control over how your operations are executed. You can define dependencies between individual operations for example, which isn't possible with plain GCD queues. It is also possible to cancel operations that have been enqueued in an NSOperationQueue (as far as the operations support it). When you enqueue a block in a GCD dispatch queue, it will definitely be executed at some point. </br></br>To sum it up, **NSOperationQueue can be more suitable for long-running operations that may need to be cancelled or have complex dependencies. GCD dispatch queues are better for short tasks that should have minimum performance and memory overhead.**

* Operation Queue에서는 동시에 실행할 수 있는 연산(Operation)의 최대 수를 지정할 수 있습니다.

* Operation Queue에서는 KVO(Key Value Observing)을 사용할 수 있는 많은 프로퍼티들이 있습니다.

* Operation Queue에서는 연산(Operation)을 일시 중지, 다시 시작 및 취소를 할 수 있습니다.

#### 💊 [Operation Queue vs Dispatch Queue for Application Example](https://www.edwith.org/boostcourse-ios)

* Operation Queue - 비동기적으로 실행되어야 하는 작업을 객체 지향적인 방법으로 사용하는 데 적합합니다. KVO(key Value Observing)를 사용해 작업 진행 상황을 감시하는 방법이 필요할 때도 적합합니다.

* GCD (Grand Central Dispatch) - 작업이 복잡하지 않고 간단하게 처리하거나 특정 유형의 시스템 이벤트를 비동기적으로 처리할 때 적합합니다. 예를 들면 타이머, 프로세스 등의 관련 이벤트입니다.

## ★ CORE DATA

* Core Data is a framework that you use to manage the model layer objects in your application. It provides generalized and automated solutions to common tasks associated with object life cycle and object graph management, including persistence.

* Core Data is an object graph and persistence framework provided by Apple in the macOS and iOS operating systems. It was introduced in Mac OS X 10.4 Tiger and iOS with iPhone SDK 3.0. It allows data organized by the relational entity–attribute model to be serialized into XML, binary, or SQLite stores. The data can be manipulated using higher level objects representing entities and their relationships. Core Data manages the serialized version, providing object lifecycle and object graph management, including persistence. Core Data interfaces directly with SQLite, insulating the developer from the underlying SQL.

#### 📄 Core Data AppDelegate Source Code

```swift
// MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "CoreDataFileName")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
```

#### 📄 Core Data Save Example Source Code

```swift
guard let appDelegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
let managedContext = appDelegate.persistentContainer.viewContext
        
// Object and Relation here.
    
do { try managedContext.save() }
catch let error as NSError { print("Could net save. \(error.debugDescription), \(error.localizedDescription)") }
```

#### 📄 Core Data Load Example Source Code

```swift
guard let appDelegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
let managedContext = appDelegate.persistentContainer.viewContext
let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Entity Name")
        
do { let objects = try managedContext.fetch(fetchRequest) as! [Object Type] } 
catch let error as NSError { print("Could net save. \(error.debugDescription), \(error.localizedDescription)") }
```

#### 📄 Core Data Delete Example Source Code

```swift
guard let appDelegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
let managedContext = appDelegate.persistentContainer.viewContext
managedContext.delete(Entity Object)
        
do { try managedContext.save() }
catch let error as NSError { print("Could net save. \(error.debugDescription), \(error.localizedDescription)") }
```

## ★ 클로저 (Closure)

* 클로저란 코드의 블럭이자, 일급 객체로 완벽한 역할을 할 수 있습니다. 일급 객체란 전달 인자로 보낼 수 있고, 변수/상수 등으로 저장하거나 전달할 수 있으며, 함수의 반환 값이 될 수도 있습니다. 실제 우리가 알고 있는 함수는 클로저의 한 형태로, 이름이 있는 클로저입니다.

#### 📄 Closure Syntax Source Code

```swift
{ (parameters) -> return type in
    statements
}
```

## ★ REFERENCE

:airplane: [iOS REFERENCE URL](https://github.com/ChangYeop-Yang/Study-iOS/issues/5)

## ★ Developer Information

|:rocket: Github QR Code|:pencil: Naver-Blog QR Code|:eyeglasses: Linked-In QR Code|
|:---------------------:|:-------------------------:|:----------------------------:|
|![](https://user-images.githubusercontent.com/20036523/50044128-60406880-00c2-11e9-8d57-ea1cb8e6b2a7.jpg)|![](https://user-images.githubusercontent.com/20036523/50044131-60d8ff00-00c2-11e9-818c-cf5ad97dc76e.jpg)|![](https://user-images.githubusercontent.com/20036523/50044130-60d8ff00-00c2-11e9-991a-107bffa2bf57.jpg)|
