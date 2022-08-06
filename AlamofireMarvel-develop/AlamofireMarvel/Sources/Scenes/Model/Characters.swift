//
//  Characters.swift
//  AlamofireMarvel
//
//  Created by Andrei Maskal on 04/08/2022.
//

import Foundation

struct Characters: Decodable {
    let count: Int?
    let all: [Character]
    
    enum CodingKeys: String, CodingKey {
        case count
        case all = "results"
    }
}
