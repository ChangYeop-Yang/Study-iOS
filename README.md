# Study-iOS
iOS (formerly iPhone OS) is a mobile operating system created and developed by Apple Inc. exclusively for its hardware. It is the operating system that presently powers many of the company's mobile devices, including the iPhone, iPad, and iPod Touch. It is the second most popular mobile operating system globally after Android.

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

* **viewDidLoad()** 
**Called when the view controller’s content view (the top of its view hierarchy) is created and loaded from a storyboard.** The view controller’s outlets are guaranteed to have valid values by the time this method is called. Use this method to perform any additional setup required by your view controller.

</br></br>**Typically, iOS calls viewDidLoad() only once, when its content view is first created;** however, the content view is not necessarily created when the controller is first instantiated. Instead, it is lazily created the first time the system or any code accesses the controller’s view property.

* **viewWillAppear()** 
**Called just before the view controller’s content view is added to the app’s view hierarchy.** Use this method to trigger any operations that need to occur before the content view is presented onscreen. Despite the name, just because the system calls this method, it does not guarantee that the content view will become visible. The view may be obscured by other views or hidden. This method simply indicates that the content view is about to be added to the app’s view hierarchy.

* **viewDidAppear()** 
**Called just after the view controller’s content view has been added to the app’s view hierarchy.** Use this method to trigger any operations that need to occur as soon as the view is presented onscreen, such as fetching data or showing an animation. Despite the name, just because the system calls this method, it does not guarantee that the content view is visible. The view may be obscured by other views or hidden. This method simply indicates that the content view has been added to the app’s view hierarchy.

* **viewWillDisappear()** 
**Called just before the view controller’s content view is removed from the app’s view hierarchy.** Use this method to perform cleanup tasks like committing changes or resigning the first responder status. Despite the name, the system does not call this method just because the content view will be hidden or obscured. This method is only called when the content view is about to be removed from the app’s view hierarchy.

* **viewDidDisappear()** 
**Called just after the view controller’s content view has been removed from the app’s view hierarchy.** Use this method to perform additional teardown activities. Despite the name, the system does not call this method just because the content view has become hidden or obscured. This method is only called when the content view has been removed from the app’s view hierarchy.

## ★ REFERENCE
* [The iOS Application Lifecycle](https://developer.apple.com/documentation/uikit/core_app/managing_your_app_s_life_cycle)
* [Managing Your App's Life Cycle - Apple](https://developer.apple.com/documentation/uikit/core_app/managing_your_app_s_life_cycle)
* [The App Life Cycle - App Programming Guide for iOS](https://developer.apple.com/library/archive/documentation/iPhone/Conceptual/iPhoneOSProgrammingGuide/TheAppLifeCycle/TheAppLifeCycle.html#//apple_ref/doc/uid/TP40007072-CH2-SW1)
* [Work with View Controllers - App Programming Guide for iOS](https://developer.apple.com/library/archive/referencelibrary/GettingStarted/DevelopiOSAppsSwift/WorkWithViewControllers.html)
