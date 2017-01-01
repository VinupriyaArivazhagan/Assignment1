//
//  AppDelegate.swift
//  Assignment1
//
//  Created by Vinupriya on 30/12/16.
//  Copyright © 2016 Vinupriya. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var locationAuthorizationStatus = LocationAuthorizationStatus.NotDetermined
    var userLocation : CLLocation = CLLocation(latitude: 0, longitude: 0)
    var locationManager:CLLocationManager!
    let googleMapsApiKey = GoogleMapsApiKey

    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        GMSServices.provideAPIKey(googleMapsApiKey)
        
        // Getting location updates
        GetLocationUpdates()
        
        return true
    }

    // MARK: Convenience
    
    class func shared() -> AppDelegate? {
        return UIApplication.sharedApplication().delegate as? AppDelegate
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // MARK: - Location Update
    func GetLocationUpdates() -> () {
        dispatch_async(dispatch_get_main_queue()) {
            self.locationManager = CLLocationManager()
            self.locationManager.delegate = self
            self.locationManager.distanceFilter = 100
            self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters // kCLLocationAccuracyBest
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.startUpdatingLocation()
        }
    }
}

extension AppDelegate: CLLocationManagerDelegate {
    //MARK: Core location delegate
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        dispatch_async(dispatch_get_main_queue()) {
            NSNotificationCenter.defaultCenter().postNotificationName(NotificationIdentifier.LocationDidFailWithError, object: nil, userInfo: ["error" : error])
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        dispatch_async(dispatch_get_main_queue()) {
            if let location = locations.first {
                self.userLocation = location
                self.locationManager.stopUpdatingLocation()
                //  self.locationClosure(result: LocationResult.Success(location))
            }
            
            NSNotificationCenter.defaultCenter().postNotificationName(NotificationIdentifier.LocationUpdate, object: nil, userInfo: ["locations" : locations])
        }
    }
    
    //MARK: Core location authorization status
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        //
        dispatch_async(dispatch_get_main_queue()) {
            switch status {
            case CLAuthorizationStatus.Restricted:
                self.locationAuthorizationStatus = .Restricted
                
            case CLAuthorizationStatus.Denied:
                self.locationAuthorizationStatus = .Denied
                
            case CLAuthorizationStatus.AuthorizedAlways, CLAuthorizationStatus.AuthorizedWhenInUse:
                self.locationAuthorizationStatus = .Allowed
                
            default:
                self.locationAuthorizationStatus = .NotDetermined
            }
            
            //
            NSNotificationCenter.defaultCenter().postNotificationName(NotificationIdentifier.LocationAccessStatus, object: nil, userInfo: nil)
        }
    }
}
