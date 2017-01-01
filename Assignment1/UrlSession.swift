//
//  UrlSession.swift
//  UTOO
//
//  Created by Siroson Mathuranga on 29/09/15.
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
    //    var tempdataTask : NSURLSessionDataTask!
    
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
                //print(error.code)
                
                //
                closure(result: Result.Failure(error))
                //                serviceCallRetryCount = 1
                
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
                    //
                    //print((response as! NSHTTPURLResponse).statusCode)
                    if (response as! NSHTTPURLResponse).statusCode == 200 {
                        do {
                            let jsonResult : [String: AnyObject]? = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? [String: AnyObject]
                            print("RESPONSE     " + "\(jsonResult)")
                            
                            let tempJsonData = try  NSJSONSerialization.dataWithJSONObject(jsonResult!, options: NSJSONWritingOptions())
                            let myJsonData : String = NSString(bytes: tempJsonData.bytes, length: tempJsonData.length, encoding: NSUTF8StringEncoding) as! String
                            print(myJsonData)
                            
                            //
                            //                            serviceCallRetryCount = 1
                            closure(result: Result.Success(jsonResult!))
                            
                        } catch let error as NSError {
                            //                            if serviceCallRetryCount > 3 {
                            print("RESPONSE JSON ERROR     " + error.localizedDescription)
                            //print(error.code)
                            
                            //
                            closure(result: Result.Failure(error))
                            //                                serviceCallRetryCount = 1
                            
                            //                            } else {
                            //                                serviceCallRetryCount += 1
                            //                                UrlSession.connectWithUrl(url, params: params, closure: closure)
                            //                            }
                        }
                        
                    } else {
                        closure(result: Result.Failure(nil))
                    }
                    
                } else {
                    //                    if serviceCallRetryCount > 3 {
                    print("SERVER ERROR     " + error!.localizedDescription)
                    //print(error!.code)
                    
                    //
                    closure(result: Result.Failure(error!))
                    //                        serviceCallRetryCount = 1
                    
                    //                    } else {
                    //                        serviceCallRetryCount += 1
                    //                        UrlSession.connectWithUrl(url, params: params, closure: closure)
                    //                    }
                }
            })
        })
        
        dataTask.resume()
    }
    
    //    class func connectWithUrl(url : NSURL, params : Dictionary<String, AnyObject>?, closure : Closure) {
    //        UrlSession().requestToTrustedServer(withURL: url, postBody: params, closure: closure)
    //    }
    
    // MARK: -
    func connectWithUrl(url : NSURL, closure : Closure) {
        if self.isServiceCalling == false {
            //print("URL    " + "\(url)")
            self.isServiceCalling = true
            let request = NSMutableURLRequest(URL:url)
            request.timeoutInterval = serviceCallTimeout
            let session = NSURLSession.sharedSession()
            
            let tempdataTask = session.dataTaskWithRequest(request, completionHandler: {
                (data, response, error) -> () in
                
                dispatch_async(dispatch_get_main_queue(), {
                    if self.isServiceCalling != false {
                        self.isServiceCalling = false
                        if error == nil {
                            do {
                                let jsonResult : [String: AnyObject]? = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? [String: AnyObject]
                                closure(result: Result.Success(jsonResult!))
                                
                            } catch let error as NSError {
                                closure(result: Result.Failure(error))
                                //print("JSON ERROR 2     " + error.localizedDescription)
                            }
                            
                        } else {
                            closure(result: Result.Failure(error!))
                            //print("SERVER ERROR     " + error!.localizedDescription)
                        }
                    }
                })
            })
            
            tempdataTask.resume()
        }
    }
    
    // MARK: - Service calls with trusted servers
    func requestToTrustedServer(withURL url: NSURL, postBody: [String: AnyObject]?, closure: Closure) {
        //
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: nil, delegateQueue: nil)
        let request = NSMutableURLRequest(URL:url)
        
        if let postBody = postBody {
            request.HTTPMethod = "POST"
            do {
                let jsonData = try  NSJSONSerialization.dataWithJSONObject(postBody, options: NSJSONWritingOptions())
                let myJsonData : String = NSString(bytes: jsonData.bytes, length: jsonData.length, encoding: NSUTF8StringEncoding) as! String
                print("REQUEST")
                print(myJsonData)
                
                request.HTTPBody = myJsonData.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
                
            } catch let error as NSError {
                print("REQUEST JSON ERROR     " + error.localizedDescription)
                print(error.code)
                
                //
                closure(result: Result.Failure(error))
                return
            }
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.timeoutInterval = serviceCallTimeout
        }
        
        session.dataTaskWithRequest(request) { (data, response, error) in
            //
            dispatch_async(dispatch_get_main_queue(), {
                if error == nil {
                    //
                    print((response as! NSHTTPURLResponse).statusCode)
                    if (response as! NSHTTPURLResponse).statusCode == 200 {
                        do {
                            let jsonResult : [String: AnyObject]? = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? [String: AnyObject]
                            //                            print(jsonResult)
                            
                            let tempJsonData = try  NSJSONSerialization.dataWithJSONObject(jsonResult!, options: NSJSONWritingOptions())
                            let myJsonData : String = NSString(bytes: tempJsonData.bytes, length: tempJsonData.length, encoding: NSUTF8StringEncoding) as! String
                            print("RESPONSE")
                            print(myJsonData)
                            
                            //
                            closure(result: Result.Success(jsonResult!))
                            
                        } catch let error as NSError {
                            print("RESPONSE JSON ERROR     " + error.localizedDescription)
                            print(error.code)
                            
                            //
                            closure(result: Result.Failure(error))
                        }
                        
                    } else {
                        closure(result: Result.Failure(nil))
                    }
                    
                } else {
                    print("SERVER ERROR     " + error!.localizedDescription)
                    print(error!.code)
                    
                    //
                    closure(result: Result.Failure(error!))
                }
            })
            
            }.resume()
    }
    
    func uploadImageToTrustedServer(url: NSURL, imageData: NSData, accessId: String, closure: Closure) {
        //print("URL    " + "\(url)")
        
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: self, delegateQueue: nil)
        let request = NSMutableURLRequest(URL:url)
        
        if let image : NSData = imageData {
            request.HTTPMethod = "POST"
            request.setValue(String(image.length), forHTTPHeaderField: "Content-Length")
            request.setValue("image/png", forHTTPHeaderField: "Content-Length")
            request.setValue(accessId, forHTTPHeaderField: "access_id")
            request.HTTPBody = image
            
            session.dataTaskWithRequest(request, completionHandler: { data, response, error in
                dispatch_async(dispatch_get_main_queue(), {
                    if error == nil {
                        do {
                            let jsonResult : [String: AnyObject]? = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? [String: AnyObject]
                            closure(result: Result.Success(jsonResult!))
                            
                        } catch let error as NSError {
                            closure(result: Result.Failure(error))
                            //print("JSON ERROR 2     " + error.localizedDescription)
                        }
                        
                    } else {
                        closure(result: Result.Failure(error!))
                        //print("SERVER ERROR     " + error!.localizedDescription)
                    }
                })
                
            }).resume()
            
        } else {
            Generals.showMessageWithTitle("Image Upload", message: ValidationMessage.imageUploadFailed)
        }
    }
    
    // MARK: - Service calls with non-trusted servers
    class func request(withURL url: NSURL, postBody: [String: AnyObject]?, closure: Closure) {
        //
        let request = NSMutableURLRequest(URL:url)
        let session = NSURLSession.sharedSession()
        
        if let postBody = postBody {
            request.HTTPMethod = "POST"
            do {
                let jsonData = try  NSJSONSerialization.dataWithJSONObject(postBody, options: NSJSONWritingOptions())
                let myJsonData : String = NSString(bytes: jsonData.bytes, length: jsonData.length, encoding: NSUTF8StringEncoding) as! String
                print(myJsonData)
                
                request.HTTPBody = myJsonData.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
                
            } catch let error as NSError {
                //print("REQUEST JSON ERROR     " + error.localizedDescription)
                //print(error.code)
                
                //
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
                    //
                    //print((response as! NSHTTPURLResponse).statusCode)
                    if (response as! NSHTTPURLResponse).statusCode == 200 {
                        do {
                            let jsonResult : [String: AnyObject]? = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? [String: AnyObject]
                            //                            print(jsonResult)
                            
                            let tempJsonData = try  NSJSONSerialization.dataWithJSONObject(jsonResult!, options: NSJSONWritingOptions())
                            let myJsonData : String = NSString(bytes: tempJsonData.bytes, length: tempJsonData.length, encoding: NSUTF8StringEncoding) as! String
                            print(myJsonData)
                            
                            closure(result: Result.Success(jsonResult!))
                            
                        } catch let error as NSError {
                            //
                            closure(result: Result.Failure(error))
                        }
                        
                    } else {
                        closure(result: Result.Failure(nil))
                    }
                    
                } else {
                    //
                    closure(result: Result.Failure(error!))
                }
            })
        })
        
        dataTask.resume()
    }
    
    // MARK: - NSURLSessionDelegates
    ///
    //    func URLSession(session: NSURLSession, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {
    //        let serverTrust = challenge.protectionSpace.serverTrust
    //        let certificate = SecTrustGetCertificateAtIndex(serverTrust!, 0)
    //
    //        // Set SSL policies for domain name check
    //        let policies = NSMutableArray();
    //        policies.addObject(SecPolicyCreateSSL(true, (challenge.protectionSpace.host)))
    //        SecTrustSetPolicies(serverTrust!, policies);
    //
    //        // Evaluate server certificate
    //        var result: SecTrustResultType = 0
    //        SecTrustEvaluate(serverTrust!, &result)
    //        let isServerTrusted:Bool = (Int(result) == kSecTrustResultUnspecified || Int(result) == kSecTrustResultProceed)
    //
    //        // Get local and remote cert data
    //        let remoteCertificateData:NSData = SecCertificateCopyData(certificate!)
    ////        let pathToCert = NSBundle.mainBundle().pathForResource("utootaxi", ofType: "cer")
    ////        let localCertificate:NSData = NSData(contentsOfFile: pathToCert!)!
    //
    ////        if (isServerTrusted && remoteCertificateData.isEqualToData(localCertificate)) {
    ////            let credential:NSURLCredential = NSURLCredential(forTrust: serverTrust!)
    ////            completionHandler(.UseCredential, credential)
    ////        } else {
    ////            completionHandler(.CancelAuthenticationChallenge, nil)
    ////        }
    //
    //        if let pathToCert = NSBundle.mainBundle().pathForResource("utootaxi", ofType: "cer"), let localCertificate:NSData = NSData(contentsOfFile: pathToCert) {
    //            if (isServerTrusted && remoteCertificateData.isEqualToData(localCertificate)) {
    //                let credential:NSURLCredential = NSURLCredential(forTrust: serverTrust!)
    //                completionHandler(.UseCredential, credential)
    //            } else {
    //                completionHandler(.CancelAuthenticationChallenge, nil)
    //            }
    //        } else {
    //            completionHandler(.CancelAuthenticationChallenge, nil)
    //        }
    //    }
}