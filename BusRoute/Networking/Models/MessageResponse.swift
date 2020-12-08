//
//  MessageResponse.swift
//  BusRoute
//
//  Created by Abeer Abbas Saber on 12/7/20.
//  Copyright © 2020 Abeer Abbas Saber. All rights reserved.
//

import Foundation

class MessagResponse: Codable {
    let innerData: [MessageInnerData]
 
    enum CodingKeys: String, CodingKey {
         case innerData = "InnerData"
    }
}

class MessageInnerData: Codable {
    let content: String
}

