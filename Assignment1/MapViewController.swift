//
//  MapViewController.swift
//  Assignment1
//
//  Created by Vinupriya on 30/12/16.
//  Copyright © 2017 Vinupriya. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    var store: Store!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let store = store,
            let latitude = store.latitude,
            let longitude = store.longitude,
            let name = store.name,
            let fullAddress = store.fullAddress {
            
            self.title = name
            
            let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: latitude.doubleValue, longitude: longitude.doubleValue))
            marker.icon = UIImage(named: "pin")
            marker.map = mapView
            marker.title = fullAddress
            
            mapView.animateToLocation(CLLocationCoordinate2D(latitude: latitude.doubleValue, longitude: longitude.doubleValue))
            self.view.makeToast("Tap on map pin to see address")
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
