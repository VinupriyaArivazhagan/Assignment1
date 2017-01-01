//
//  ServiceHandler.swift
//  Assignment1
//
//  Created by Vinupriya on 30/12/16.
//  Copyright © 2017 Vinupriya. All rights reserved.
//

import UIKit

enum ServiceResponse {
    case Success(Any?)
    case Failure(Any?)
}

enum ServiceHandlerError: ErrorType {
    case error
}

typealias ServiceCompletionHandler = (ServiceResponse) -> ()

class ServiceHandler: NSObject {

    class func getStores(completionClosure: ServiceCompletionHandler) {
        
        UrlSession.connectWithUrl(NSURL(string: Url.getStores)!, params: nil) { (result) in
            switch result {
            case .Success(let response):
                do {
                    let storesResult = try getResponse(response)
                    
                    var stores = [Store]()
                    for store in storesResult {
                        stores.append(Store(name: store["Name"], streetAddress: store["StreetAddress"], postalCode: store["PostalCode"], city: store["City"], storeId: store["StoreId"], latitude: store["Lat"], longitude: store["Long"]))
                    }
                    completionClosure(ServiceResponse.Success(stores))
                }
                catch ServiceHandlerError.error {
                    Generals.showMessageWithTitle("OOPS!", message: ValidationMessage.commonError)
                    completionClosure(ServiceResponse.Failure(nil))
                }
                catch {
                    Generals.showMessageWithTitle("OOPS!", message: ValidationMessage.commonError)
                    completionClosure(ServiceResponse.Failure(nil))
                }
                
            case .Failure(_):
                
                result.showErrorMessage()
                completionClosure(ServiceResponse.Failure(nil))
            }
        }
    }
    
    // MARK: -
    private class func getResponse(serviceresponse : AnyObject?) throws -> [[String : AnyObject]] {
        guard let response : [String : AnyObject] = serviceresponse as? [String : AnyObject] else {
            throw ServiceHandlerError.error
        }
        
        guard let storesResult = response["GetAllStoresResult"] as? [String: AnyObject],
        let stores = storesResult["StoreList"] as? [[String: AnyObject]] else {
            
            throw ServiceHandlerError.error
        }
        
        return stores
    }
}
