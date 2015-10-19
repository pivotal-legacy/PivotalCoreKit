## HEAD

## 0.3.1 (in progress)

  * Further improvements to UIGestureRecognizer spec helper stub
  * Improvements to PCK's fake operation queue.
  * Adds support for inspecting the urls opened with UIApplication
  * Adds support for inspecting the `-cameraDevice` set on a UIImagePickerController
  * UINavigationController stubs are now properly loaded.
  * Adds a `triggerNonSegueAction` category on WKInterfaceButton to help test non-segue actions in WatchKit
  * Adds support for testing the configuration of WKInterfaceButtons with content type group in WatchKit
  * Adds ability to toggle UIViewController spec stubs
  * Adds support for inspecting data loaded directly into UIWebViews

## 0.3.0

  * Adds instructions for releasing new versions of PivotalCoreKit
  * Adds a stub for setting [CLLocationManager +authorizationStatus]
  * Includes improvements to the UIGestureRecognizer stub
  * Improves UIBarButtonItem, UISwitch and UISegmentedControl test helpers
  * Drops build-time support for iOS 7

## 0.2.3

  * Update WatchKit framework for Xcode 6.2 beta 4
  * Add support for testing UIAlertController

## 0.2.2

  * Adds support for testing wiring of WatchKit apps in Cedar/XCTest/etc.

## 0.2.1
  * No functional changes - fixes red build due to spec bug

## 0.2.0
  * Breaking change: UIKit project targets are reorganized to keep stubs and helpers separate
  * Introduces more functional programming additions to the Foundation project

## 0.1.1
  * Fixes to podspec for Cocoapods users
  * Cocoapods projects should no longer see warnings appear when using PCK libs as pod dependencies

## 0.1.0

### Major Enhancements
  * Adds NSDictionary+dictionaryFromQueryString
  * Adds support for loading nib-based UIView subclasses from other nibs with internal bindings and constraints intact
  * Adds typesafe extraction methods to NSDictionary
  * Adds a stub for UIActivityViewController
  * UIKit+PivotalSpecHelperStubs static library and CocoaPods subspec is converted to ARC
  * Manually triggering gesture recognizers can perform storyboard segues
  * Adds support for instantiating prototype table view and collection view cells given a view controller from a storyboard and a cell identifier
  * Improves support for UIGestureRecognizer
  * Adds support for UINavigationController iOS 8 changes

### Minor Enhancements
  * FakeOperationQueue is renamed to PSHKFakeOperationQueue; an alias is provided for backward compatibility
  * Removes need to whitelist target classes before manually triggering gesture recognizers

### Bug Fixes

## 0.0.3 / 2014-03-10
  * first versioned release
