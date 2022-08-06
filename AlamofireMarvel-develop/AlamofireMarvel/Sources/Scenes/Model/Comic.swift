//
//  Comic.swift
//  AlamofireMarvel
//
//  Created by Andrei Maskal on 03/08/2022.
//

import Foundation

struct ComicList: Decodable {
    let items: [ComicSummary]?
}

struct ComicSummary: Decodable {
    let name: String?
}
