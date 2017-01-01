//
//  Generals.swift
//  UTOO
//
//  Created by Siroson Mathuranga on 15/10/15.
//  Copyright © 2015 UTOO Cabs Limited. All rights reserved.
//

import UIKit
import Crashlytics

var rateView : RateAlert?
var cancelAlertView: CancelAlertView!
var blockDriverView: BlockDriverView!
var qrcodeAlertView : QRCodeAlertView!

////
//var smLoadingView : SMLoadingView?

////
var quickBookView: QuickBookView?
var helpScreenView: HelpScreen!
var imagePreview: ImagePreview?
var passwordAuthenticationView: PasswordAuthenticationView!

class Generals: NSObject {
    
    class func showMessageWithTitle(title: String, message : String) -> () {
        
        //        let alertView = UNAlertView(title: title, message: message, alertImage: "common_alert")
        //        alertView.addButton("OK", backgroundColor: UIColor.clearColor(), fontColor: Color.Theme) { () -> Void in
        //        }
        //
        //        alertView.show()
        
        Generals.showMessageWithTitle(title, message: message, alertImage: "common_alert")
    }
    
    class func showMessageWithTitle(title: String, message : String, withTextField : UITextField?) -> () {
        
        //        let alertView = UNAlertView(title: title, message: message, alertImage: "common_alert")
        //        alertView.addButton("OK", backgroundColor: UIColor.clearColor(), fontColor: Color.Theme) { () -> Void in
        //        }
        //
        //        alertView.show()
        withTextField?.resignFirstResponder()
        Generals.showMessageWithTitle(title, message: message, alertImage: "common_alert", withTextField: withTextField)
    }
    
    class func showMessageWithTitle(title: String, message : String, alertImage: String?) -> () {
        dispatch_async(dispatch_get_main_queue(), {
            let alertView = UNAlertView(title: title, message: message, alertImage: alertImage)
            alertView.addButton("OK", backgroundColor: UIColor.clearColor(), fontColor: Color.Theme) { () -> Void in
            }
            
            alertView.show()
        })
    }
    
    class func showMessageWithTitle(title: String, message : String, alertImage: String?, withTextField : UITextField?) -> () {
        dispatch_async(dispatch_get_main_queue(), {
            let alertView = UNAlertView(title: title, message: message, alertImage: alertImage)
            alertView.addButton("OK", backgroundColor: UIColor.clearColor(), fontColor: Color.Theme) { () -> Void in
                withTextField?.becomeFirstResponder()
            }
            
            alertView.show()
        })
    }
    
    class func isValidEmail(strEmail : String) -> Bool {
        let emailRegEx = "[0-9a-zA-Z._%+-]+@[a-zA-Z.-]+\\.[a-zA-Z]{2,6}"
        //        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(strEmail)
    }
    
    class func getErrorMessage(errorCode : NSNumber) -> String {
        //// Checking if errorCode is invalid user access_id
        if errorCode == Validation.InvalidAccessID {
            AppDelegate.SharedDelegate().Logout()
        }
        
//        //// Checking if errorCode is invalid driver access_id
//        if errorCode == 5075 {
//            if let access_id = KeyChainHandler.loadUserData(OfType: kSecAccessIDIdentifier) {
//                //// Getting fresh lookup data
//                Generals.getLookupListWithAccessId(access_id, homeController: nil)
//            }
//            
//            //// Informing user to try again after fresh lookup data is retrieved
//            return "Please try again."
//        }
        
        if (Generals.getValuesFromUserDefaults("LookUpList")?.objectForKey("response_code")) != nil
        {
            var arrResponseCodes : [AnyObject]  = (Generals.getValuesFromUserDefaults("LookUpList")?.objectForKey("response_code"))! as! [AnyObject]
            let resultPredicate = NSPredicate(format: "SELF.response_code == \(errorCode)")
            arrResponseCodes = arrResponseCodes.filter { resultPredicate.evaluateWithObject($0) }
            if arrResponseCodes.count > 0
            {
                return arrResponseCodes[0].valueForKey("response_description") as! String
            }
        }
        
        return ValidationMessage.unknownError
    }
    
    class func getTariffDetails(cartype : String) -> [String : AnyObject]! {
        if (Generals.getValuesFromUserDefaults("LookUpList")?.objectForKey("tariff")) != nil //(NSUserDefaults.standardUserDefaults().valueForKey("LookUpList")?.objectForKey("tariff")) != nil
        {
            //            var arrtariff : [AnyObject]  = (NSUserDefaults.standardUserDefaults().valueForKey("LookUpList")?.objectForKey("tariff"))! as! [AnyObject]
            var arrtariff : [AnyObject]  = (Generals.getValuesFromUserDefaults("LookUpList")?.objectForKey("tariff"))! as! [AnyObject]
            let resultPredicate = NSPredicate(format: "SELF.carmodel_id.car_model_name contains[cd] %@", cartype)
            arrtariff = arrtariff.filter { resultPredicate.evaluateWithObject($0) }
            if arrtariff.count > 0 {
                return arrtariff[0] as! [String : AnyObject]
            }
        }
        
        return nil
    }
    
    class func getUnBookList() -> [AnyObject] {
        if (Generals.getValuesFromUserDefaults("LookUpList")?.objectForKey("unbook_reasons")) != nil // (NSUserDefaults.standardUserDefaults().valueForKey("LookUpList")?.objectForKey("unbook_reasons")) != nil
        {
            if let arrtariff : [AnyObject]  = Generals.getValuesFromUserDefaults("LookUpList")?.objectForKey("unbook_reasons") as? [AnyObject] //NSUserDefaults.standardUserDefaults().valueForKey("LookUpList")?.objectForKey("unbook_reasons") as? [AnyObject]
            {
                if arrtariff.count > 0 {
                    return arrtariff
                }
            }
        }
        
        return [AnyObject]()
    }
    
    class func getBlockedReasons() -> [AnyObject] {
        if Generals.getValuesFromUserDefaults("LookUpList")?.objectForKey("blocked_reasons") != nil // (NSUserDefaults.standardUserDefaults().valueForKey("LookUpList")?.objectForKey("blocked_reasons")) != nil
        {
            if let arrtariff : [AnyObject]  = Generals.getValuesFromUserDefaults("LookUpList")?.objectForKey("blocked_reasons") as? [AnyObject] //NSUserDefaults.standardUserDefaults().valueForKey("LookUpList")?.objectForKey("blocked_reasons") as? [AnyObject]
            {
                if arrtariff.count > 0 {
                    var tempArray: [NSDictionary] = NSArray(array: arrtariff) as! [NSDictionary]
                    tempArray.sortInPlace { (dictOne, dictTwo) -> Bool in
                        let reaon_id_1 = dictOne["blocked_reason_id"] as? Int
                        let reaon_id_2 = dictTwo["blocked_reason_id"] as? Int
                        
                        return reaon_id_1 < reaon_id_2
                    }
                    
                    return tempArray
                }
            }
        }
        
        return [AnyObject]()
    }
    
    class func getCarTypes() -> NSArray? {
        if let dict = Generals.getValuesFromUserDefaults("LookUpList") //NSUserDefaults.standardUserDefaults().valueForKey("LookUpList")
        {
            if let arrCarTypes = dict["car_model"] as? [NSDictionary] {
                return arrCarTypes
            }
        }
        
        return nil
    }
    
    class func GetPromo() -> String? {
        if let promo_code = Generals.getValuesFromUserDefaults("promo_code_lookup") as? String // NSUserDefaults.standardUserDefaults().valueForKey("promo_code_lookup") as? String
        {
            return promo_code
        }
        
        return nil
    }
    
    // MARK: - Service Calls
//    class func GetLookupList() {
//        if Generals.getValuesFromUserDefaults("LookUpList") == nil // NSUserDefaults.standardUserDefaults().valueForKey("LookUpList") == nil
//        {
//            
//            let dictPostBody = ["is_all" : false,"is_response_codes" : true , "is_server_details" : true, "is_car_model_details" : true, "is_car_features_details" : false , "is_tariff_details": true, "is_need_unbook_reason_list" : true, "is_need_location_list":true, "is_need_blocked_list":true]
//            
//            AppDelegate.SharedDelegate().ShowLoadingView(LoadingTitle.common)
//            UrlSession.connectWithUrl(NSURL(string: Config.InitialURL + "lookup")!, params: dictPostBody, closure: { result in
//                AppDelegate.SharedDelegate().HideLoadingView()
//                
//                switch result {
//                case let .Success(response):
//                    if response["status"] as! NSNumber == NSNumber(int: 1) {
//                        //                        NSUserDefaults.standardUserDefaults().setValue(response["response"], forKey: "LookUpList")
//                        Generals.saveValuesIntoUserDefaults(response["response"], key: "LookUpList")
//                        let arrServerPath : [AnyObject]  = Generals.getValuesFromUserDefaults("LookUpList")?.objectForKey("server_path")! as! [NSArray] //(NSUserDefaults.standardUserDefaults().valueForKey("LookUpList")?.objectForKey("server_path"))! as! [NSArray]
//                        let dictPath : [String : AnyObject] = arrServerPath[0] as! [String : AnyObject]
//                        let profilePath = (dictPath["base_path"]! as! String) + "/" + (dictPath["base_folder"]! as! String) + "/" + (dictPath["passenger_profile_photo"]! as! String)
//                        let driver_profilePath = (dictPath["base_path"]! as! String) + "/" + (dictPath["base_folder"]! as! String) + "/" + (dictPath["profile_photo"]! as! String)
//                        
//                        if let promo_code = dictPath["promo_code"] as? String {
//                            Generals.saveValuesIntoUserDefaults(promo_code, key: "promo_code_lookup")
//                            //                            NSUserDefaults.standardUserDefaults().setValue(promo_code, forKey: "promo_code_lookup")
//                        }
//                        Generals.saveValuesIntoUserDefaults(profilePath, key: PASSENGER_PROFILE_PATH)
//                        Generals.saveValuesIntoUserDefaults(driver_profilePath, key: DRIVER_PROFILE_PATH)
//                        //                        NSUserDefaults.standardUserDefaults().setValue(profilePath, forKey: PASSENGER_PROFILE_PATH)
//                        //                        NSUserDefaults.standardUserDefaults().setValue(driver_profilePath, forKey: DRIVER_PROFILE_PATH)
//                        //                        NSUserDefaults.standardUserDefaults().synchronize()
//                        
//                    } else {
//                        Generals.showMessageWithTitle("Error", message: Generals.getErrorMessage(response["error"] as! NSNumber))
//                    }
//                    
//                case let .Failure(error):
//                    if error != nil {
//                        if error!.code == NSURLErrorNotConnectedToInternet {
//                            Generals.showMessageWithTitle("OOPS!", message: ValidationMessage.notConnectedToInternet)
//                        } else if error!.code == NSURLErrorNetworkConnectionLost {
//                            Generals.showMessageWithTitle("OOPS!", message: ValidationMessage.networkConnectionLost)
//                        } else if error!.code == NSURLErrorBadURL {
//                            Generals.showMessageWithTitle("OOPS!", message: ValidationMessage.badUrl)
//                        } else if error!.code == NSURLErrorTimedOut {
//                            Generals.showMessageWithTitle("OOPS!", message: ValidationMessage.timedOut)
//                        } else {
//                            Generals.showMessageWithTitle("OOPS!", message: ValidationMessage.commonError)
//                        }
//                    } else {
//                        Generals.showMessageWithTitle("OOPS!", message: ValidationMessage.commonError)
//                    }
//                }
//            })
//        }
//    }
    
//    class func getLookupListWithAccessId(access_id: String, homeController: HomeViewController?) {
//        let dictPostBody: [String: AnyObject] = ["is_all" : true, "access_id": access_id]
//        
//        AppDelegate.SharedDelegate().ShowLoadingView(LoadingTitle.common)
//        UrlSession.connectWithUrl(NSURL(string: Config.InitialURL + "lookup")!, params: dictPostBody, closure: { result in
//            AppDelegate.SharedDelegate().HideLoadingView()
//            
//            switch result {
//            case let .Success(response):
//                if response["status"] as! NSNumber == NSNumber(int: 1) {
//                    //                    NSUserDefaults.standardUserDefaults().setValue(response["response"], forKey: "LookUpList")
//                    Generals.saveValuesIntoUserDefaults(response["response"], key: "LookUpList")
//                    let arrServerPath : [AnyObject]  = Generals.getValuesFromUserDefaults("LookUpList")?.objectForKey("server_path")! as! [NSArray] //(NSUserDefaults.standardUserDefaults().valueForKey("LookUpList")?.objectForKey("server_path"))! as! [NSArray]
//                    let dictPath : [String : AnyObject] = arrServerPath[0] as! [String : AnyObject]
//                    let profilePath = (dictPath["base_path"]! as! String) + "/" + (dictPath["base_folder"]! as! String) + "/" + (dictPath["passenger_profile_photo"]! as! String)
//                    let driver_profilePath = (dictPath["base_path"]! as! String) + "/" + (dictPath["base_folder"]! as! String) + "/" + (dictPath["profile_photo"]! as! String)
//                    
//                    if let promo_code = dictPath["promo_code"] as? String {
//                        Generals.saveValuesIntoUserDefaults(promo_code, key: "promo_code_lookup")
//                        //                        NSUserDefaults.standardUserDefaults().setValue(promo_code, forKey: "promo_code_lookup")
//                    }
//                    
//                    Generals.saveValuesIntoUserDefaults(profilePath, key: PASSENGER_PROFILE_PATH)
//                    Generals.saveValuesIntoUserDefaults(driver_profilePath, key: DRIVER_PROFILE_PATH)
//                    //                    NSUserDefaults.standardUserDefaults().setValue(profilePath, forKey: PASSENGER_PROFILE_PATH)
//                    //                    NSUserDefaults.standardUserDefaults().setValue(driver_profilePath, forKey: DRIVER_PROFILE_PATH)
//                    //                    NSUserDefaults.standardUserDefaults().synchronize()
//                    
//                    if let response = response["response"] as? NSDictionary {
//                        Drivers.deleteAllDrivers()
//                        for driver in (response["drivers"] as? NSArray)! {
//                            Drivers.insertNewDriver(driver as! NSDictionary)
//                        }
//                        
//                        if let blocked_drivers = response["blocked_drivers"] as? NSArray {
//                            for blocked_driver in blocked_drivers {
//                                var access_id: String?
//                                var block_reason: String?
//                                
//                                if let obooking = blocked_driver["obooking"] as? NSDictionary {
//                                    if let odrivers = obooking["odrivers"] as? NSDictionary {
//                                        if let temp_access_id = odrivers["access_id"] as? String {
//                                            access_id = temp_access_id
//                                            
//                                            if let temp_block_reason = blocked_driver["block_Reason"] as? String {
//                                                block_reason = temp_block_reason
//                                            }
//                                            
//                                            let booking_number = obooking["booking_number"] as! String
//                                            Drivers.blockDriver(access_id!, booking_number: booking_number, block_reason: block_reason)
//                                        }
//                                    }
//                                }
//                            }
//                        }
//                        
//                        Favourites.deleteAllFavourites()
//                        if let favourites = response["favourites"] as? NSArray {
//                            for favourite in favourites {
//                                Favourites.insertFavourite(favourite as! NSDictionary)
//                            }
//                        }
//                        
//                        // Save current booking
//                        CurrentBooking.deleteAllBookings()
//                        if let arrBooking = response["booking"] as? NSArray where arrBooking.count > 0 {
//                            //
//                            if let booking = arrBooking[0] as? [String: AnyObject] {
//                                Generals.saveCurrentBookingFromLookup(booking)
//                            }
//                        }
//                        
//                        //
//                        if let loyalty_points = response["loyalty_points"] as? NSNumber {
//                            Generals.saveValuesIntoUserDefaults("\(loyalty_points)", key: "loyalty_points")
//                            //                            NSUserDefaults.standardUserDefaults().setValue("\(loyalty_points)", forKey: "loyalty_points")
//                        }
//                    }
//                    
//                } else {
//                    Generals.showMessageWithTitle("Session Expired", message: ValidationMessage.sessionExpired)
//                }
//                
//            case let .Failure(error):
//                if error != nil {
//                    if error!.code == NSURLErrorNotConnectedToInternet {
//                        Generals.showMessageWithTitle("OOPS!", message: ValidationMessage.notConnectedToInternet)
//                    } else if error!.code == NSURLErrorNetworkConnectionLost {
//                        Generals.showMessageWithTitle("OOPS!", message: ValidationMessage.networkConnectionLost)
//                    } else if error!.code == NSURLErrorBadURL {
//                        Generals.showMessageWithTitle("OOPS!", message: ValidationMessage.badUrl)
//                    } else if error!.code == NSURLErrorTimedOut {
//                        Generals.showMessageWithTitle("OOPS!", message: ValidationMessage.timedOut)
//                    } else {
//                        Generals.showMessageWithTitle("OOPS!", message: ValidationMessage.commonError)
//                    }
//                    
//                } else {
//                    Generals.showMessageWithTitle("OOPS!", message: ValidationMessage.commonError)
//                }
//            }
//        })
//    }
    
    //    class func serviceCallGetBookingHistoryInBackground() {
    //        let arrUserAccount = UserAccount.getData()
    //        let userAccount : UserAccount = arrUserAccount[0] as! UserAccount
    //        let dictPostBody : [String : String] = ["access_id" : userAccount.access_id!]
    //
    //        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    //        UrlSession.connectWithUrl(NSURL(string: Config.BookingURL + "getbookinghistory")!, params: dictPostBody, closure: {result in
    //            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    //
    //            switch result {
    //            case let .Success(response):
    //                if response["status"] as! NSNumber == NSNumber(int: 1) {
    //                    Generals.getCurrentBooking(response["response"] as! [NSDictionary])
    //                }
    //
    //            case let .Failure(error):
    //                //print(error.localizedDescription)
    //            }
    //        })
    //    }
    
    class func getChannelName(coordinate : CLLocationCoordinate2D, isUserLocation : Bool) -> String {
        if Generals.getValuesFromUserDefaults("LookUpList") != nil //NSUserDefaults.standardUserDefaults().valueForKey("LookUpList") != nil
        {
            let arrLocation : [[String : AnyObject]]  = Generals.getValuesFromUserDefaults("LookUpList")?.objectForKey("location") as! [[String : AnyObject]] //NSUserDefaults.standardUserDefaults().valueForKey("LookUpList")?.objectForKey("location") as! [[String : AnyObject]]
            for dictLocation in arrLocation {
                let north_latitude = dictLocation["north_latitude"] as! Double
                let south_latitude = dictLocation["south_latitude"] as! Double
                let east_longitude = dictLocation["east_longitude"] as! Double
                let west_longitude = dictLocation["west_longitude"] as! Double
                let nearLeft : CLLocationCoordinate2D = CLLocationCoordinate2DMake(north_latitude, east_longitude)
                let farRight : CLLocationCoordinate2D = CLLocationCoordinate2DMake(south_latitude, west_longitude)
                let bounds = GMSCoordinateBounds(coordinate: nearLeft, coordinate: farRight)
                
                if !isUserLocation {
                    AppDelegate.SharedDelegate().visibleBounds = bounds
                }
                
                if bounds.containsCoordinate(coordinate) {
                    return dictLocation["channel"] as! String
                }
            }
        }
        
        return ""
    }
    
    // MARK: - Rate Pop up
    class func ShowRateView(rateInfo: NSDictionary?) -> () {
        if rateView == nil {
            //
            Generals.logEvent(named: "Viewed Rate Card", attributes: nil)
            
            //
            let con : UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("RateAlert")
            rateView  = con.view as? RateAlert
            
            rateView?.lblRACarType.text = "--"
            rateView?.lblRAFlatAmount.text = "--"
            rateView?.lblRAPerKm.text = "--"
            rateView?.lblRAPerMin.text = ""
            
            if let info = rateInfo {
                if let carmodel_id = info["carmodel_id"] as? NSDictionary {
                    if let car_model_name = carmodel_id["car_model_name"] as? String {
                        rateView?.lblRACarType.text = car_model_name
                    
                        if car_model_name == "Compact" {
                            rateView?.imgCarType.image = UIImage(named: "rate_luxury")
                        } else if car_model_name == "Sedan" {
                            rateView?.imgCarType.image = UIImage(named: "rate_super_luxe")
                        } else if car_model_name == "SUV" {
                            rateView?.imgCarType.image = UIImage(named: "rate_suv")
                        } else {
                            rateView?.imgCarType.image = UIImage(named: "rate_super_luxe")
                        }
                        
                    } else {
                        rateView?.imgCarType.image = UIImage(named: "rate_super_luxe")
                    }
                }
                
                if let flat_amount = info["flat_amount"] as? NSNumber {
                    let strFullText = "₹\(flat_amount)"
                    let strRupee = "₹"
                    let rangeOfRupee = (strFullText as NSString).rangeOfString(strRupee)
                    
                    let attributedString = NSMutableAttributedString(string: strFullText)
                    attributedString.addAttribute(NSForegroundColorAttributeName, value: Color.SecondaryBlack, range: rangeOfRupee)
                    attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: Font.Regular, size: 15.0)!, range: rangeOfRupee)
                    
                    rateView?.lblRAFlatAmount.attributedText = attributedString
                    //                rateView.lblRAFlatAmount.text = "₹\(flat_amount)"
                }
                
                if let charge_per_kms = info["charge_per_kms"] as? NSNumber {
                    let strFullText = "₹\(charge_per_kms)/km"
                    let strRupee = "₹"
                    let strPerkm = "/km"
                    let rangeOfRupee = (strFullText as NSString).rangeOfString(strRupee)
                    let rangeOfPerkm = (strFullText as NSString).rangeOfString(strPerkm)
                    
                    let attributedString = NSMutableAttributedString(string: strFullText)
                    attributedString.addAttribute(NSForegroundColorAttributeName, value: Color.SecondaryBlack, range: rangeOfRupee)
                    attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: Font.Regular, size: 15.0)!, range: rangeOfRupee)
                    attributedString.addAttribute(NSForegroundColorAttributeName, value: Color.SecondaryBlack, range: rangeOfPerkm)
                    attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: Font.Regular, size: 15.0)!, range: rangeOfPerkm)
                    
                    //
                    rateView?.lblRAPerKm.attributedText = attributedString
                    //                rateView.lblRAPerKm.text = "₹\(charge_per_kms) /km"
                }
                
                if let charge_per_min = info["charge_per_min"] as? NSNumber {
                    let strFullText = "₹\(charge_per_min)/min"
                    let strRupee = "₹"
                    let strPerMin = "/min"
                    let rangeOfRupee = (strFullText as NSString).rangeOfString(strRupee)
                    let rangeOfPerMin = (strFullText as NSString).rangeOfString(strPerMin)
                    
                    let attributedString = NSMutableAttributedString(string: strFullText)
                    attributedString.addAttribute(NSForegroundColorAttributeName, value: Color.SecondaryBlack, range: rangeOfRupee)
                    attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: Font.Regular, size: 15.0)!, range: rangeOfRupee)
                    attributedString.addAttribute(NSForegroundColorAttributeName, value: Color.SecondaryBlack, range: rangeOfPerMin)
                    attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: Font.Regular, size: 15.0)!, range: rangeOfPerMin)
                    
                    //
                    rateView?.lblRAPerMin.attributedText = attributedString
                    //                rateView.lblRAPerMin.text = "₹\(charge_per_min) /min"
                }
            }
            
            //
            AppDelegate.SharedDelegate().window!.addSubview(rateView!)
            rateView?.center = AppDelegate.SharedDelegate().window!.center
        }
    }
    
    class func HideRateView() -> () {
        rateView?.removeFromSuperview()
        rateView = nil
    }
    
    class func getCarType(car_model_id : Int) -> String {
        if Generals.getValuesFromUserDefaults("LookUpList") != nil// NSUserDefaults.standardUserDefaults().valueForKey("LookUpList") != nil
        {
            if let arrLocation : [[String : AnyObject]]  = Generals.getValuesFromUserDefaults("LookUpList")?.objectForKey("car_model") as? [[String : AnyObject]] //NSUserDefaults.standardUserDefaults().valueForKey("LookUpList")?.objectForKey("car_model") as? [[String : AnyObject]]
            {
                for dictLocation in arrLocation {
                    if car_model_id == dictLocation["car_model_id"] as! Int {
                        return dictLocation["car_model_name"] as! String
                    }
                }
            }
        }
        
        return ""
    }
    
    class func getAllCarTypes() -> [[String: AnyObject]]? {
        if Generals.getValuesFromUserDefaults("LookUpList") != nil// NSUserDefaults.standardUserDefaults().valueForKey("LookUpList") != nil
        {
            if let arrCarTypes = Generals.getValuesFromUserDefaults("LookUpList")?.objectForKey("car_model") as? [[String : AnyObject]] //NSUserDefaults.standardUserDefaults().valueForKey("LookUpList")?.objectForKey("car_model") as? [[String : AnyObject]]
            {
                return arrCarTypes
            }
        }
        
        return nil
    }
    
    class func getAllCarTypes(loading : Bool) ->(arrCarType : [[String : AnyObject]], arrTime : [String], arrProgress: [Float])// [String: AnyObject]?
    {
        if Generals.getValuesFromUserDefaults("LookUpList") != nil {
            if let arrCarTypes = Generals.getValuesFromUserDefaults("LookUpList")?.objectForKey("car_model") as? [[String : AnyObject]] {
                let tempArrCarTypes = arrCarTypes.filter({ (info) -> Bool in
                    if let is_deleted = info["is_deleted"] as? NSNumber where is_deleted == 0 {
                        return true
                    }
                    
                    return false
                })
                
                var arrProgress : [Float] = []
                var arrTime : [String] = []
                for _ in 0 ..< tempArrCarTypes.count
                {
                    arrProgress.append(0.0)
                    if loading
                    {
                        arrTime.append("calculating")
                    }
                    else
                    {
                        arrTime.append("No cars")
                    }
                }
                return (tempArrCarTypes, arrTime, arrProgress) //["arrCarType" : arrCarTypes, "arrProgess" : arrProgress, "arrTime": arrTime]
            }
        }
        
        return ([], [], [])
    }
    
    class func getCarId(car_model_name : String) -> String? {
        if Generals.getValuesFromUserDefaults("LookUpList") != nil// NSUserDefaults.standardUserDefaults().valueForKey("LookUpList") != nil
        {
            if let arrLocation : [[String : AnyObject]]  = Generals.getValuesFromUserDefaults("LookUpList")?.objectForKey("car_model") as? [[String : AnyObject]] //NSUserDefaults.standardUserDefaults().valueForKey("LookUpList")?.objectForKey("car_model") as? [[String : AnyObject]]
            {
                for dictLocation in arrLocation {
                    if car_model_name == dictLocation["car_model_name"] as! String {
                        return "\(dictLocation["car_model_id"] as! Int)"
                    }
                }
            }
        }
        
        return nil
    }
    
    // MARK: - QRCodeAlertView
    class func showQRCodeAlertView(controller : QRCodeScannerViewController) {
        let con : UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("QRCodeAlertView")
        qrcodeAlertView  = con.view as! QRCodeAlertView
        qrcodeAlertView.delegate = controller
        AppDelegate.SharedDelegate().window!.addSubview(qrcodeAlertView)
    }
    
    // MARK: - Cancel Alert View
    class func ShowCancelAlertView(controller : TrackViewController?, bookDetail : BookingDetailViewController?, dictBookingDetails : [String : AnyObject]) {
        let con : UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CancelAlertView")
        cancelAlertView  = con.view as! CancelAlertView
        cancelAlertView.delegate = controller
        cancelAlertView.bookDetaildelegate = bookDetail
        cancelAlertView.dictBookDetails = dictBookingDetails
        cancelAlertView.frame = (AppDelegate.SharedDelegate().window?.frame)!
        AppDelegate.SharedDelegate().window!.addSubview(cancelAlertView)
    }
    
    class func ShowCancelAlertView(quickBookView: QuickBookView, dictBookingDetails : [String : AnyObject]) {
        let con : UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CancelAlertView")
        cancelAlertView  = con.view as! CancelAlertView
        cancelAlertView.delegate = quickBookView
        cancelAlertView.dictBookDetails = dictBookingDetails
        cancelAlertView.frame = (AppDelegate.SharedDelegate().window?.frame)!
        AppDelegate.SharedDelegate().window!.addSubview(cancelAlertView)
    }
    
    class func ShowBlockDriverView(controller: BookingDetailViewController?, dictBookingDetails: [String : AnyObject]) {
        let con : UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("BlockDriverView")
        blockDriverView  = con.view as! BlockDriverView
        blockDriverView.blockDriverDelegate = controller
        blockDriverView.dictBookDetails = dictBookingDetails
        blockDriverView.frame = (AppDelegate.SharedDelegate().window?.frame)!
        AppDelegate.SharedDelegate().window!.addSubview(blockDriverView)
    }
    
    class func HideCancelAlertView() -> () {
        cancelAlertView.removeFromSuperview()
    }
    
    class func HideBlockDriverView() -> () {
        if blockDriverView != nil {
            blockDriverView.removeFromSuperview()
        }
    }
    
    // MARK: - Documents dicrectory
    class func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    class func saveImageToDisk(image: UIImage, imageName: String) {
        let imagePath = getDocumentsDirectory().stringByAppendingPathComponent(imageName)
        
        if let jpegData = UIImagePNGRepresentation(image) {
            jpegData.writeToFile(imagePath, atomically: true)
        }
    }
    
    class func getImageFromDisk(imageName: String) -> UIImage? {
        var image : UIImage?
        let imagePath = getDocumentsDirectory().stringByAppendingPathComponent(imageName)
        
        if NSFileManager.defaultManager().fileExistsAtPath(imagePath) {
            let url = NSURL.fileURLWithPath(imagePath)
            let imgData = NSData(contentsOfURL: url)
            image = UIImage(data: imgData!)
        }
        
        return image
    }
    
    class func deleteImageFromDisk(imageName: String) {
        let imagePath = getDocumentsDirectory().stringByAppendingPathComponent(imageName)
        
        do {
            if NSFileManager.defaultManager().fileExistsAtPath(imagePath) {
                try NSFileManager.defaultManager().removeItemAtPath(imagePath)
            }
        } catch {
            
        }
    }
    
    // MARK: - Quick Book
    class func addQuickBookView(controller: HomeViewController, showImmediately: Bool) {
        if quickBookView == nil {
            let con = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("QuickBookView") as UIViewController
            quickBookView  = con.view as? QuickBookView
            quickBookView!.homeViewController = controller
            
            //
            AppDelegate.SharedDelegate().window!.addSubview(quickBookView!)
            
            //
//            if showImmediately {
//                quickBookView!.frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height)
//            } else {
                quickBookView!.frame = CGRect(x: UIScreen.mainScreen().bounds.width, y: 0, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height)
//            }
            
        } else {
            if showImmediately {
                Generals.showQuickBookView()
            }
        }
    }
    
    class func resetQuickBookView(status: QuickBookStatus) {
        if quickBookView != nil {
            // Do not allow reset if previous status is "Block"
            if quickBookView?.quickBookStatus == .Block {
                // Check if incoming status is "Unblock", in which case allow to reset
                if status == .Unblock {
                    quickBookView?.resetQuickBookView(status)
                }
                
            } else {
                quickBookView?.resetQuickBookView(status)
            }
        }
    }
    
    class func removeQuickBookView() {
        if quickBookView != nil {
            quickBookView!.removeFromSuperview()
            quickBookView = nil
        }
    }
    
    class func showQuickBookView() {
        if quickBookView != nil {
            if quickBookView?.quickBookStatus != .Block {
                // Check if incoming status is "Unblock", in which case allow to reset
                quickBookView!.showQuickBookView()
            }
        }
    }
    
    class func showQuickBookView(controller: HomeViewController, showImmediately: Bool) {
        //
        if quickBookView != nil {
            quickBookView!.showQuickBookView()
            
        } else {
            Generals.removeQuickBookView()
            Generals.addQuickBookView(controller, showImmediately: showImmediately)
        }
    }
    
    class func hideQuickBookView() {
        if quickBookView != nil {
            quickBookView!.hideQuickBookView()
        }
    }
    
    // MARK: - Help Screen
    class func showHelpScreenView(controller: HomeViewController) {
        let con = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("HelpScreenView") as UIViewController
        helpScreenView  = con.view as! HelpScreen
        helpScreenView.frame = AppDelegate.SharedDelegate().window!.frame
        helpScreenView.homeViewController = controller
        AppDelegate.SharedDelegate().window!.addSubview(helpScreenView)
        AppDelegate.SharedDelegate().window!.bringSubviewToFront(helpScreenView)
    }
    
    // MARK: - Image Preview
    class func showImagePreviewView(image: UIImage?, imgURLString: String?) {
        if imagePreview == nil {
            if image == nil && imgURLString == nil {
                Generals.showMessageWithTitle("Invalid Image", message: "Profile picture seems to be invalid.")
                
            } else {
                imagePreview = ImagePreview(frame: AppDelegate.SharedDelegate().window!.frame, image: image, imgURLString: imgURLString)
            }
        }
    }
    
    class func removeImagePreview() {
        if imagePreview != nil {
            imagePreview!.removeGestureRecognizer(imagePreview!.singleTapGesture)
            
            //
            imagePreview!.removeFromSuperview()
            imagePreview = nil
        }
    }
    
    // MARK: - Password Authentication View
    class func showPasswordAuthenticationView(callbackController callbackController: ProfileViewController) {
        if passwordAuthenticationView == nil {
            let con = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("PasswordAuthenticationViewIdentifier") as UIViewController
            passwordAuthenticationView  = con.view as! PasswordAuthenticationView
            passwordAuthenticationView.frame = AppDelegate.SharedDelegate().window!.frame
            passwordAuthenticationView.delegate = callbackController
            AppDelegate.SharedDelegate().window!.addSubview(passwordAuthenticationView)
            AppDelegate.SharedDelegate().window!.bringSubviewToFront(passwordAuthenticationView)
            
        } else {
            passwordAuthenticationView = nil
            Generals.showPasswordAuthenticationView(callbackController: callbackController)
        }
    }
    
    class func removePasswordAuthenticationView() {
        if passwordAuthenticationView != nil {
            passwordAuthenticationView.removeFromSuperview()
            passwordAuthenticationView = nil
        }
    }
    
    // MARK: - Bearing Calculation
    class func getBearing(fromCoordinate: CLLocationCoordinate2D, toCoordinate: CLLocationCoordinate2D) -> Double {
        let fLat = ((M_PI * fromCoordinate.latitude) / 180.0)
        let fLon = ((M_PI * fromCoordinate.longitude) / 180.0)
        let tLat = ((M_PI * toCoordinate.latitude) / 180.0)
        let tLon = ((M_PI * toCoordinate.longitude) / 180.0)
        
        let rad = atan2(sin(tLon-fLon)*cos(tLat), cos(fLat)*sin(tLat)-sin(fLat)*cos(tLat)*cos(tLon-fLon))
        let degree = ((rad * 180.0) / M_PI)
        
        if (degree >= 0) {
            return degree;
        } else {
            return 360+degree;
        }
    }
    
    // MARK: - Resize Image
    class func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        image.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    // MARK: - Dynamic Label Height
    class func getLabelHeightFor(text text:String, font: UIFont, width: CGFloat, numberOfLines: Int) -> CGFloat {
        let lbl = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: 0))
        lbl.numberOfLines = numberOfLines
        lbl.font = font
        lbl.text = text
        lbl.sizeToFit()
        
        //print(lbl.frame.size.height)
        
        if lbl.frame.size.height > 20 {
            return lbl.frame.size.height
        } else {
            return 20
        }
    }
    
    // MARK: - Split address array
    class func getFilteredAddress(address address: String) -> (addressLineOne: String, addressLineTwo: String) {
        var addressLineOne = "--"
        var addressLineTwo = "--"
        
        var arr: [String] = address.componentsSeparatedByString(",")
        
        // Looping through array to remove excessive spaces
        for (index, element) in arr.enumerate() {
            let tempElement = element.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            arr.removeAtIndex(index)
            arr.insert(tempElement, atIndex: index)
        }
        
        // Looping through array to find a non-numeric string
        for (index, element) in arr.enumerate() {
            //
            if addressLineOne == "--" {
                let tempStr = element.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                let invalidCharacters = "1234567890_+<-\\/@#$%^&*!)("
                
                let range: NSRange = (tempStr as NSString).rangeOfCharacterFromSet(NSCharacterSet(charactersInString: invalidCharacters))
                if range.location == NSNotFound {
                    //print("Found string:    \(tempStr)")
                    addressLineOne = tempStr
                    arr.removeAtIndex(index)
                    break
                }
                
            } else {
                break
            }
        }
        
        //
        if arr.count > 0 {
            addressLineTwo = arr.joinWithSeparator(", ")
        }
        
        return (addressLineOne, addressLineTwo)
    }
    
    // MARK: - Save Current Booking
    class func saveCurrentBookingFromLookup(booking: [String: AnyObject]) {
        //
        var bookingInfo = [String : AnyObject]()
        var driverInfo = [String : AnyObject]()
        var userInfo = [String : AnyObject]()
        
        // Driver Info
        if let odrivers = booking["odrivers"] as? [String: AnyObject] {
            driverInfo = odrivers
        }
        
        // Booking Info
        if let group_book_key = booking["group_book_key"] as? String {
            bookingInfo["group_book_key"] = group_book_key
        }
        
        if let status = booking["status"] as? NSNumber {
            bookingInfo["status"] = "\(status)"
        }
        
        if let booking_number = booking["booking_number"] as? String {
            bookingInfo["booking_number"] = booking_number
        }
        
        if let pbr_number = booking["pbr_number"] as? String {
            bookingInfo["pbr_number"] = pbr_number
        }
        
        if let booked_dat = booking["booked_dat"] as? String {
            bookingInfo["booked_date"] = booked_dat
        }
        
        if let booking_type = booking["booking_type"] as? NSNumber {
            bookingInfo["booking_type"] = "\(booking_type)"
        }
        
        // User Info
        if let bto_name = booking["bto_name"] as? String {
            userInfo["passenger_name"]  = bto_name
        }
        
        if let bto_mobile = booking["bto_mobile"] as? NSNumber {
            userInfo["passenger_mobile"]  = "\(bto_mobile)"
        }
        
        if let pickup_address = booking["actual_source"] as? String {
            userInfo["pickup_address"]  = pickup_address
        } else {
            if let pickup_address = booking["booked_source"] as? String {
                userInfo["pickup_address"]  = pickup_address
            }
        }
        
        if let pickup_latitude = booking["actual_source_latitude"] as? NSNumber where Double(pickup_latitude) != 0 {
            userInfo["pickup_latitude"]  = Double(pickup_latitude)
        } else {
            if let pickup_latitude = booking["departure_latitude"] as? NSNumber {
                userInfo["pickup_latitude"]  = Double(pickup_latitude)
            }
        }
        
        if let pickup_longitude = booking["actual_source_longitude"] as? NSNumber where Double(pickup_longitude) != 0 {
            userInfo["pickup_longitude"]  = Double(pickup_longitude)
        } else {
            if let pickup_longitude = booking["departure_longitude"] as? NSNumber {
                userInfo["pickup_longitude"]  = Double(pickup_longitude)
            }
        }
        
        if let drop_address = booking["actual_dest"] as? String {
            userInfo["drop_address"]  = drop_address
        } else {
            if let drop_address = booking["booked_destination"] as? String {
                userInfo["drop_address"]  = drop_address
            }
        }
        
        if let drop_latitude = booking["actual_dest_latitude"] as? NSNumber where Double(drop_latitude) != 0 {
            userInfo["drop_latitude"]  = Double(drop_latitude)
        } else {
            if let drop_latitude = booking["reaching_latitude"] as? NSNumber {
                userInfo["drop_latitude"]  = Double(drop_latitude)
            }
        }
        
        if let drop_longitude = booking["actual_dest_longitude"] as? NSNumber where Double(drop_longitude) != 0 {
            userInfo["drop_longitude"]  = Double(drop_longitude)
        } else {
            if let drop_longitude = booking["reaching_longitude"] as? NSNumber {
                userInfo["drop_longitude"]  = Double(drop_longitude)
            }
        }
        
        //
        if bookingInfo.count > 0 && driverInfo.count > 0 && userInfo.count > 0 {
            CurrentBooking.addCurrentBooking(bookingInfo, driverInfo: driverInfo, userInfo: userInfo)
        }
    }
    
    class func setSecretForUserDefaults()
    {
        if Generals.getValuesFromUserDefaults("AfterUpdate") == nil
        {
            if let secretKey = KeyChainHandler.getSecretKey()
            {
                if let access_id = KeyChainHandler.loadUserData(OfType: kSecAccessIDIdentifier) // User is already logged in
                {
                    //
                    NSUserDefaults.standardUserDefaults().setSecret(secretKey)
                    
                    if let value : [String : AnyObject] = NSUserDefaults.standardUserDefaults().secretObjectForKey("LookUpList") as? [String : AnyObject] {
                        let token = Generals.getDeviceID()
                        //
                        Keychain.removeValue(forKey: kSecSecretKey)
                        let appDomain = NSBundle.mainBundle().bundleIdentifier!
                        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain)
                        
                        Generals.saveValuesIntoUserDefaults("yes", key: "AfterUpdate")
                        Generals.saveValuesIntoUserDefaults("yes", key: "Login")
                        Generals.saveValuesIntoUserDefaults(value, key: "LookUpList")
                        
                        let arrServerPath : [AnyObject]  = Generals.getValuesFromUserDefaults("LookUpList")?.objectForKey("server_path")! as! [NSArray]
                        let dictPath : [String : AnyObject] = arrServerPath[0] as! [String : AnyObject]
                        let profilePath = (dictPath["base_path"]! as! String) + "/" + (dictPath["base_folder"]! as! String) + "/" + (dictPath["passenger_profile_photo"]! as! String)
                        let driver_profilePath = (dictPath["base_path"]! as! String) + "/" + (dictPath["base_folder"]! as! String) + "/" + (dictPath["profile_photo"]! as! String)
                        
                        if let promo_code = dictPath["promo_code"] as? String {
                            Generals.saveValuesIntoUserDefaults(promo_code, key: "promo_code_lookup")
                        }
                        
                        Generals.saveValuesIntoUserDefaults(profilePath, key: PASSENGER_PROFILE_PATH)
                        Generals.saveValuesIntoUserDefaults(driver_profilePath, key: DRIVER_PROFILE_PATH)
                        Generals.saveValuesIntoUserDefaults(false, key: "isFirstRun")
                        
                        Generals.saveValuesIntoUserDefaults("+914446467676", key: "support_contact_number")
                        Generals.saveValuesIntoUserDefaults("support@utoo.cab", key: "support_email_address")
                        
                        Generals.saveValuesIntoUserDefaults(token, key: "device_id")
                        Generals.saveValuesIntoUserDefaults("0", key: "loyalty_points")
                        
                    } else {
                        Keychain.removeValue(forKey: kSecSecretKey)
                        let appDomain = NSBundle.mainBundle().bundleIdentifier!
                        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain)
                        Generals.saveValuesIntoUserDefaults("yes", key: "AfterUpdate")
                        
                        ServiceHandler.logOutInBackground(withPostBody: ["access_id" : access_id], completionHandler: nil)
                    }
                    
                } else {
                    Keychain.removeValue(forKey: kSecSecretKey)
                    
                    let appDomain = NSBundle.mainBundle().bundleIdentifier!
                    NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain)
                    
                    Generals.saveValuesIntoUserDefaults("yes", key: "AfterUpdate")
                    AppDelegate.SharedDelegate().Logout()
                }
                
            } else { // v1.1.3
                if let access_id = KeyChainHandler.loadUserData(OfType: kSecAccessIDIdentifier) // User is already logged in
                {
                    if let value : [String : AnyObject] = Generals.getValuesFromUserDefaults("LookUpList") as? [String : AnyObject] {
                        let token = Generals.getDeviceID()
                        //
                        let appDomain = NSBundle.mainBundle().bundleIdentifier!
                        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain)
                        
                        Generals.saveValuesIntoUserDefaults("yes", key: "AfterUpdate")
                        Generals.saveValuesIntoUserDefaults("yes", key: "Login")
                        Generals.saveValuesIntoUserDefaults(value, key: "LookUpList")
                        
                        let arrServerPath : [AnyObject]  = Generals.getValuesFromUserDefaults("LookUpList")?.objectForKey("server_path")! as! [NSArray]
                        let dictPath : [String : AnyObject] = arrServerPath[0] as! [String : AnyObject]
                        let profilePath = (dictPath["base_path"]! as! String) + "/" + (dictPath["base_folder"]! as! String) + "/" + (dictPath["passenger_profile_photo"]! as! String)
                        let driver_profilePath = (dictPath["base_path"]! as! String) + "/" + (dictPath["base_folder"]! as! String) + "/" + (dictPath["profile_photo"]! as! String)
                        
                        if let promo_code = dictPath["promo_code"] as? String {
                            Generals.saveValuesIntoUserDefaults(promo_code, key: "promo_code_lookup")
                        }
                        
                        Generals.saveValuesIntoUserDefaults(profilePath, key: PASSENGER_PROFILE_PATH)
                        Generals.saveValuesIntoUserDefaults(driver_profilePath, key: DRIVER_PROFILE_PATH)
                        Generals.saveValuesIntoUserDefaults(false, key: "isFirstRun")
                        
                        Generals.saveValuesIntoUserDefaults("+914446467676", key: "support_contact_number")
                        Generals.saveValuesIntoUserDefaults("support@utoo.cab", key: "support_email_address")
                        
                        Generals.saveValuesIntoUserDefaults(token, key: "device_id")
                        Generals.saveValuesIntoUserDefaults("0", key: "loyalty_points")
                        
                    } else {
                        let appDomain = NSBundle.mainBundle().bundleIdentifier!
                        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain)
                        Generals.saveValuesIntoUserDefaults("yes", key: "AfterUpdate")
                        
                        ServiceHandler.logOutInBackground(withPostBody: ["access_id" : access_id], completionHandler: nil)
                    }
                    
                } else {
                    let appDomain = NSBundle.mainBundle().bundleIdentifier!
                    NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain)
                    
                    Generals.saveValuesIntoUserDefaults("yes", key: "AfterUpdate")
                    AppDelegate.SharedDelegate().Logout()
                }
            }
        }
    }
    
    class func getValuesFromUserDefaults(key : String) -> AnyObject? {
        if let value = NSUserDefaults.standardUserDefaults().valueForKey(key){
            return value
        }
        return nil
    }
    
    class func saveValuesIntoUserDefaults(value: AnyObject? , key : String)
    {
        NSUserDefaults.standardUserDefaults().setObject(value, forKey: key)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    class func removeValuesFromUserDefaults(key : String)
    {
        if NSUserDefaults.standardUserDefaults().valueForKey(key) != nil
        {
            NSUserDefaults.standardUserDefaults().removeObjectForKey(key)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    // MARK: - Crashlytics/Answers Log Events
    class func logEvent(named eventName: String, attributes: [String: AnyObject]?) {
        Answers.logCustomEventWithName(eventName, customAttributes: nil)
    }
    
    // MARK: - 
    class func getDeviceID() -> String {
        if let device_id = Generals.getValuesFromUserDefaults("device_id") as? String {
            return device_id
        }
        
        return "0"
    }
    
    //MARK:- Lookup date difference
    
    class func daysFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Day, fromDate: date, toDate: NSDate(), options: []).day
    }
    
    class func minutesFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Minute, fromDate: date, toDate: NSDate(), options: []).minute
    }
}