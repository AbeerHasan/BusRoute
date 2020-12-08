//
//  RoutePath.swift
//  BusRoute
//
//  Created by Abeer Abbas Saber on 12/7/20.
//  Copyright © 2020 Abeer Abbas Saber. All rights reserved.
//

import Foundation

class BusResponse : Codable  {
    let data : BusInnerData
    
    enum CodingKeys: String, CodingKey {
        case data = "InnerData"
    }
}

class BusInnerData : Codable{
    let token: String
    let user : User
}

class User : Codable{
    let bus : Bus
}

class Bus : Codable {
    let route : Route
}

class Route : Codable {
    let routePath : [DropoffLocation]
    let stop_points : [DropoffLocation]
}

class DropoffLocation : Codable {
    let lat , lng : Double
}
