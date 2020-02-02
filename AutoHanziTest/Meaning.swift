//
//  Meaning.swift
//  AutoHanziTest
//
//  Created by Ghost on 2020/02/02.
//  Copyright © 2020 autogroup. All rights reserved.
//

import Foundation

class Meaning: Codable {
    let type: String
    let desc: String
    let example: String?
    let explanation: String?
    
    enum CodingKeys: String, CodingKey {
        case type = "type"
        case desc = "description"
        case example = "example"
        case explanation = "explanation"
    }
}
