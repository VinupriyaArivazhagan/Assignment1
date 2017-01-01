//
//  Generals.swift
//  UTOO
//
//  Created by Vinupriya on 30/12/16.
//  Copyright © 2015 UTOO Cabs Limited. All rights reserved.
//

import UIKit

class Generals: NSObject {
    
    class func showMessageWithTitle(title: String, message : String) -> () {
        
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: .Alert)
        AppDelegate.shared()?.window?.visibleViewController?.presentViewController(alertController, animated: true, completion: nil)
    }
    
}