//
//  Store.swift
//  Assignment1
//
//  Created by Vinupriya on 30/12/16.
//  Copyright © 2017 Vinupriya. All rights reserved.
//

import UIKit


struct Store {

    var name: String?
    var streetAddress: String?
    var postalCode: String?
    var city: String?
    var storeId: String?
    var fullAddress: String?
    var latitude: NSNumber?
    var longitude: NSNumber?
    
    init(name: AnyObject?, streetAddress: AnyObject?, postalCode: AnyObject?, city: AnyObject?, storeId: AnyObject?, latitude: AnyObject?, longitude: AnyObject?) {
        
        if let name = name as? String {
            self.name = name
        }
        
        self.fullAddress = ""
        
        if let streetAddress = streetAddress as? String {
            self.streetAddress = streetAddress
            self.fullAddress = streetAddress
        }
        
        if let city = city as? String {
            self.city = city
            var address = ""
            
            if let fullAddress = self.fullAddress where fullAddress != "" {
                address = fullAddress + ", "
            }
            self.fullAddress = address + city
        }
        
        if let postalCode = postalCode as? String {
            self.postalCode = postalCode
            
            var address = ""
            
            if let fullAddress = self.fullAddress where fullAddress != "" {
                address = fullAddress + ", "
            }
            self.fullAddress = address + postalCode
        }
        
        if let storeId = storeId as? String {
            self.storeId = storeId
        }
        
        if let latitude = latitude as? NSNumber {
            self.latitude = latitude
        }
        
        if let longitude = longitude as? NSNumber {
            self.longitude = longitude
        }
    }
    
}
