//
//  Constants.swift
//  Assignment1
//
//  Created by Vinupriya on 30/12/16.
//  Copyright © 2016 Vinupriya. All rights reserved.
//

import UIKit

let GoogleMapsApiKey = "AIzaSyBoEPCROWgqTJT57-ustRdU2KwZ3j5uYaw"

enum LocationAuthorizationStatus {
    case Restricted
    case Denied
    case Allowed
    case NotDetermined
}

struct NotificationIdentifier {
    static let LocationDidFailWithError = "LocationDidFailWithError"
    static let LocationUpdate = "LocationUpdate"
    static let LocationAccessStatus = "LocationAccessStatus"
}

// MARK: - Validation Messages
struct ValidationMessage {
    //
    static let commonError = "A problem occurred while connecting to server, please try again."
    static let notConnectedToInternet = "You are not connected to internet."
    static let networkConnectionLost = "Network connection is lost, please try again later."
    static let badUrl = "Failed to connect to server, please try again later."
    static let timedOut = "Network connection timed out, please try again later."
    static let NonTrustedServer = "You are routing through a proxy server. For security reasons try switching to a different network or switch off HTTP proxy in your WiFi settings."
}

struct Url {
    
    static let getStores = "https://svcs.axfood.se/RestServiceOpen.svc/json/getAllStores?MembershipProgramId=1"
}