//
//  Bus.swift
//  BusRoute
//
//  Created by Abeer Abbas Saber on 12/7/20.
//  Copyright © 2020 Abeer Abbas Saber. All rights reserved.
//


import Foundation
import Alamofire

enum NetworkingSetup {
    case getBusRouteAndStopPoints(name: String, password: String, deviceToken: String?)
    case getHTMLMessage
}

extension NetworkingSetup : TargetType{
    var baseURL: String {
        switch self {
        default:
            return BASE_URL
        }
    }
    var path: String {
        switch self {
        case .getBusRouteAndStopPoints:
            return CHECKCREDENTIALS_URL
        case .getHTMLMessage:
            return ABOUTUS_URL
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getBusRouteAndStopPoints:
            return .post
        case .getHTMLMessage:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getBusRouteAndStopPoints(let name, let password, let deviceToken):
            return .requestParemeters(parameters: ["name" : name, "password" : password, "deviceToken": deviceToken ?? ""], encoding: JSONEncoding.default)
        case .getHTMLMessage:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            return HEADERS
        }
    }
}
