//
//  NetworkProviderErrorHandler.swift
//  AlamofireMarvel
//
//  Created by Andrei Maskal on 04/08/2022.
//

import Foundation

protocol NetworkProviderErrorHandler {
    var delegate: NetworkProviderDelegate? { get set }
}
