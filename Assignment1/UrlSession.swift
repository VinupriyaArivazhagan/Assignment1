//
//  UrlSession.swift
//  UTOO
//
//  Created by Vinupriya on 30/12/16.
//  Copyright © 2015 UTOO Cabs Limited. All rights reserved.
//


private var serviceCallTimeout = 25.0

import UIKit

// service call result Success failure enum
enum Result {
    case Success([String: AnyObject])
    case Failure(NSError?)
    
    func showErrorMessage() {
        switch self {
        case .Success(_): break
            
        case .Failure(let error):
            if error == nil {
                Generals.showMessageWithTitle("OOPS!", message: ValidationMessage.commonError)
            } else {
                switch error!.code {
                case NSURLErrorNotConnectedToInternet:
                    Generals.showMessageWithTitle("OOPS!", message: ValidationMessage.notConnectedToInternet)
                    
                case NSURLErrorNetworkConnectionLost:
                    Generals.showMessageWithTitle("OOPS!", message: ValidationMessage.networkConnectionLost)
                    
                case NSURLErrorBadURL:
                    Generals.showMessageWithTitle("OOPS!", message: ValidationMessage.badUrl)
                    
                case NSURLErrorTimedOut:
                    Generals.showMessageWithTitle("OOPS!", message: ValidationMessage.timedOut)
                    
                case NSURLErrorCancelled:
                    Generals.showMessageWithTitle("Security Alert", message: ValidationMessage.NonTrustedServer)
                    
                default:
                    Generals.showMessageWithTitle("OOPS!", message: ValidationMessage.commonError)
                }
            }
        }
    }
}

typealias Closure = (result: Result) -> () // service call completion closure

class UrlSession: NSObject, NSURLSessionDelegate {
    
    class var sharedInstance: UrlSession {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: UrlSession? = nil
        }
        
        dispatch_once(&Static.onceToken) {
            Static.instance = UrlSession()
        }
        
        return Static.instance!
    }
    
    var isServiceCalling : Bool = false
    
    // MARK: -
    class func connectWithUrl(url : NSURL, params : Dictionary<String, AnyObject>?, closure : Closure) {
        print("URL    " + "\(url)")
        print("POSTBODY     " + "\(params)")
        
        let request = NSMutableURLRequest(URL:url)
        let session = NSURLSession.sharedSession()
        
        if let postBody = params {
            request.HTTPMethod = "POST"
            do {
                let jsonData = try  NSJSONSerialization.dataWithJSONObject(postBody, options: NSJSONWritingOptions())
                let myJsonData : String = NSString(bytes: jsonData.bytes, length: jsonData.length, encoding: NSUTF8StringEncoding) as! String
                print(myJsonData)
                
                request.HTTPBody = myJsonData.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
                
            } catch let error as NSError {
                print("REQUEST JSON ERROR     " + error.localizedDescription)
                
                closure(result: Result.Failure(error))
                
                return
            }
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.timeoutInterval = serviceCallTimeout
        }
        
        //
        let dataTask : NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: {
            (data, response, error) -> () in
            
            dispatch_async(dispatch_get_main_queue(), {
                if error == nil {

                    if (response as! NSHTTPURLResponse).statusCode == 200 {
                        do {
                            let jsonResult : [String: AnyObject]? = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? [String: AnyObject]
                            print("RESPONSE     " + "\(jsonResult)")
                            
                            let tempJsonData = try  NSJSONSerialization.dataWithJSONObject(jsonResult!, options: NSJSONWritingOptions())
                            let myJsonData : String = NSString(bytes: tempJsonData.bytes, length: tempJsonData.length, encoding: NSUTF8StringEncoding) as! String
                            print(myJsonData)
                            
                            closure(result: Result.Success(jsonResult!))
                            
                        } catch let error as NSError {
                            
                            print("RESPONSE JSON ERROR     " + error.localizedDescription)
                            
                            //
                            closure(result: Result.Failure(error))
                            
                        }
                        
                    } else {
                        closure(result: Result.Failure(nil))
                    }
                    
                } else {
                    print("SERVER ERROR     " + error!.localizedDescription)
                    
                    closure(result: Result.Failure(error!))
                    
                }
            })
        })
        
        dataTask.resume()
    }}