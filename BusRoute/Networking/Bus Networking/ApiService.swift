//
//  BusAPI.swift
//  BusRoute
//
//  Created by Abeer Abbas Saber on 12/7/20.
//  Copyright © 2020 Abeer Abbas Saber. All rights reserved.
//

import Foundation

protocol BaseAPIProtocol {
     func getBusRouteAndStopPoints(name: String, password: String, deviceToken: String, completion: @escaping (Result<BusResponse?, NSError>) -> ())
     func getHtmlPageContent(completion: @escaping (Result<MessagResponse?, NSError>) -> ())
}

class ApiService: BaseAPI<NetworkingSetup>, BaseAPIProtocol {
    
    func getBusRouteAndStopPoints(name: String, password: String, deviceToken: String, completion: @escaping (Result<BusResponse?, NSError>) -> ()){
        self.fetchData(target: .getBusRouteAndStopPoints(name: name, password: password, deviceToken: deviceToken), responseClass: BusResponse.self) { (result) in
            completion(result)
        }
    }
    
    func getHtmlPageContent(completion: @escaping (Result<MessagResponse?, NSError>) -> ()){
        self.fetchData(target: .getHTMLMessage, responseClass: MessagResponse.self) { (result) in
            completion(result)
        }
    }
}
