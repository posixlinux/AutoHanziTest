//
//  Hanzi.swift
//  AutoHanziTest
//
//  Created by Ghost on 2020/02/02.
//  Copyright © 2020 autogroup. All rights reserved.
//

import Foundation

struct Hanzi: Codable {
    let word: String
    var meanings: [Meaning]
    
    enum CodingKeys: String, CodingKey {
        case word = "word"  
        case meanings = "meaning"
    }
}
