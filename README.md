# Study-iOS
iOS (formerly iPhone OS) is a mobile operating system created and developed by Apple Inc. exclusively for its hardware. It is the operating system that presently powers many of the company's mobile devices, including the iPhone, iPad, and iPod Touch. It is the second most popular mobile operating system globally after Android.

## ★ Automatic Reference Counting (ARC)

|ARC Image 001|ARC Image 002|
|:-----------:|:-----------:|
|![](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/MemoryMgmt/Art/memory_management_2x.png)|![](https://developer.apple.com/library/archive/releasenotes/ObjectiveC/RN-TransitioningToARC/Art/ARC_Illustration.jpg)|

* Automatic Reference Counting (ARC) is a memory management feature of the Clang compiler providing automatic reference counting for the Objective-C and Swift programming languages. **At compile time, it inserts into the object code messages retain and release which increase and decrease the reference count at run time, marking for deallocation those objects when the number of references to them reaches zero.**
</br></br> ARC differs from tracing garbage collection in that there is no background process that deallocates the objects asynchronously at runtime. Unlike garbage collection, ARC does not handle reference cycles automatically. This means that as long as there are "strong" references to an object, it will not be deallocated. **Strong cross-references can accordingly create deadlocks and memory leaks. It is up to the developer to break cycles by using weak references.**
</br></br> Apple Inc. deploys ARC in their operating systems, such as macOS (OS X) and iOS. Limited support (ARCLite) has been available since Mac OS X Snow Leopard and iOS 4, with complete support following in Mac OS X Lion and iOS 5. Garbage collection was declared deprecated in OS X Mountain Lion, in favor of ARC, and removed from the Objective-C runtime library in macOS Sierra.

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

<p align="center">
  <img src="https://docs-assets.developer.apple.com/published/f5ae1a0785/00b28327-17dc-4f0c-866f-29f854edfce3.png" width="350" height="350" />
</p>

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
  <img src="https://docs-assets.developer.apple.com/published/cfb6ae10b1/high_level_flow_2x_2bc77269-019d-4554-83b8-6aeecb73c348.png" width="350" height="350" />
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

* **viewWillDisappear**</br>
**Called just before the view controller’s content view is removed from the app’s view hierarchy.** Use this method to perform cleanup tasks like committing changes or resigning the first responder status. Despite the name, the system does not call this method just because the content view will be hidden or obscured. This method is only called when the content view is about to be removed from the app’s view hierarchy.

* * *

* **viewDidDisappear**</br>
**Called just after the view controller’s content view has been removed from the app’s view hierarchy.** Use this method to perform additional teardown activities. Despite the name, the system does not call this method just because the content view has become hidden or obscured. This method is only called when the content view has been removed from the app’s view hierarchy.

* * *

* **viewDidLayoutSubviews**</br>
**Called to notify the view controller that its view has just laid out its subviews.** When the bounds change for a view controller's view, the view adjusts the positions of its subviews and then the system calls this method. However, this method being called does not indicate that the individual layouts of the view's subviews have been adjusted. Each subview is responsible for adjusting its own layout.
</br></br>Your view controller can override this method to make changes after the view lays out its subviews. The default implementation of this method does nothing.

* * *

* **viewWillLayoutSubviews**</br>
Called to notify the view controller that its view is about to layout its subviews. When a view's bounds change, the view adjusts the position of its subviews. Your view controller can override this method to make changes before the view lays out its subviews. The default implementation of this method does nothing.

## ★ UIKit

#### # UITableView

* A table view displays a list of items in a single column. UITableView is a subclass of UIScrollView, which allows users to scroll through the table, although UITableView allows vertical scrolling only. The cells comprising the individual items of the table are UITableViewCell objects; UITableView uses these objects to draw the visible rows of the table. Cells have content—titles and images—and can have, near the right edge, accessory views. Standard accessory views are disclosure indicators or detail disclosure buttons; the former leads to the next level in a data hierarchy and the latter leads to a detailed view of a selected item. Accessory views can also be framework controls, such as switches and sliders, or can be custom views. Table views can enter an editing mode where users can insert, delete, and reorder rows of the table.

###### ※ UITableViewDataSource

```swift
    // N 번째 섹션에 몇 개의 Row가 존재하는지를 반환하는 메소드
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    // N 번째 섹션에 M 번째 Row를 그리는데 필요한 셀을 반환하는 메소드
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Basic Type
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell Identification")
        
        // Custom Type
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell Identification", for: indexPath) as! Cell Type
        
        return cell
    }
```

###### ※ UITableViewDelegate

```swift
    // 사용자가 Cell을 선택시 Cell의 인덱스를 반환하는 메소드
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)     {
        if (editingStyle == .delete) {
            // Delete Tableview cell here
        }
    }
```

## ★ CORE ML

* Core ML is the foundation for domain-specific frameworks and functionality. Core ML supports Vision for image analysis, Natural Language for natural language processing, and GameplayKit for evaluating learned decision trees. Core ML itself builds on top of low-level primitives like Accelerate and BNNS, as well as Metal Performance Shaders.

* Core ML is optimized for on-device performance, which minimizes memory footprint and power consumption. Running strictly on the device ensures the privacy of user data and guarantees that your app remains functional and responsive when a network connection is unavailable.

|Core ML Image 001|Core ML Image 002|
|:---------:|:---------:|
|![](https://docs-assets.developer.apple.com/published/7e05fb5a2e/4b0ecf58-a51a-4bfa-a361-eb77e59ed76e.png)|![](https://docs-assets.developer.apple.com/published/479d7b4500/0c857af6-45e4-4fac-ad84-4aeb8c01b5a3.png)|

## ★ CORE DATA

* Core Data is a framework that you use to manage the model layer objects in your application. It provides generalized and automated solutions to common tasks associated with object life cycle and object graph management, including persistence.

* Core Data is an object graph and persistence framework provided by Apple in the macOS and iOS operating systems. It was introduced in Mac OS X 10.4 Tiger and iOS with iPhone SDK 3.0. It allows data organized by the relational entity–attribute model to be serialized into XML, binary, or SQLite stores. The data can be manipulated using higher level objects representing entities and their relationships. Core Data manages the serialized version, providing object lifecycle and object graph management, including persistence. Core Data interfaces directly with SQLite, insulating the developer from the underlying SQL.

#### ※ Core Data Save Example

```swift
guard let appDelegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
let managedContext = appDelegate.persistentContainer.viewContext
        
// Object and Relation here.
    
do { try managedContext.save() }
catch let error as NSError { print("Could net save. \(error.debugDescription), \(error.localizedDescription)") }
```

#### ※ Core Data Load Example

```swift
guard let appDelegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
let managedContext = appDelegate.persistentContainer.viewContext
let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Entity Name")
        
do { let objects = try managedContext.fetch(fetchRequest) as! [Object Type] } 
catch let error as NSError { print("Could net save. \(error.debugDescription), \(error.localizedDescription)") }
```

#### ※ Core Data Delete Example

```swift
guard let appDelegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
let managedContext = appDelegate.persistentContainer.viewContext
managedContext.delete(Entity Object)
        
do { try managedContext.save() }
catch let error as NSError { print("Could net save. \(error.debugDescription), \(error.localizedDescription)") }
```

## ★ REFERENCE
* [The iOS Application Lifecycle](https://developer.apple.com/documentation/uikit/core_app/managing_your_app_s_life_cycle)
* [Managing Your App's Life Cycle - Apple](https://developer.apple.com/documentation/uikit/core_app/managing_your_app_s_life_cycle)
* [The App Life Cycle - App Programming Guide for iOS](https://developer.apple.com/library/archive/documentation/iPhone/Conceptual/iPhoneOSProgrammingGuide/TheAppLifeCycle/TheAppLifeCycle.html#//apple_ref/doc/uid/TP40007072-CH2-SW1)
* [Work with View Controllers - App Programming Guide for iOS](https://developer.apple.com/library/archive/referencelibrary/GettingStarted/DevelopiOSAppsSwift/WorkWithViewControllers.html)
* [viewDidLayoutSubviews - App Programming Guide for iOS](https://developer.apple.com/documentation/uikit/uiviewcontroller/1621398-viewdidlayoutsubviews)
* [View Controller Lifecycle Explained: When to Use viewDidLayoutSubviews](https://www.appcoda.com/view-controller-lifecycle/)
* [Automatic Reference Counting - 위키백과](https://en.wikipedia.org/wiki/Automatic_Reference_Counting)
* [Transitioning to ARC Release Notes - Apple](https://developer.apple.com/library/archive/releasenotes/ObjectiveC/RN-TransitioningToARC/Introduction/Introduction.html#//apple_ref/doc/uid/TP40011226)
* [Core ML - Apple](https://developer.apple.com/documentation/coreml)
* [Core ML and Vision: Machine Learning in iOS 11 Tutorial](https://www.raywenderlich.com/577-core-ml-and-vision-machine-learning-in-ios-11-tutorial)
* [Memory management - App Programming Guide for iOS](https://developer.apple.com/library/archive/documentation/General/Conceptual/DevPedia-CocoaCore/MemoryManagement.html#//apple_ref/doc/uid/TP40008195-CH27-SW1)
* [What Is Core Data? - App Programming Guide for iOS](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CoreData/index.html#//apple_ref/doc/uid/TP40001075-CH2-SW1)
* [Core Data - 위키백과](https://en.wikipedia.org/wiki/Core_Data)
* [UITableView - App Programming Guide for iOS](https://developer.apple.com/documentation/uikit/uitableview)
