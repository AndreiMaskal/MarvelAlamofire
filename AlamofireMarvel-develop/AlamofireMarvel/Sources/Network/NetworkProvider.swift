//
//  NetworkProvider.swift
//  AlamofireMarvel
//
//  Created by Andrei Maskal on 04/08/2022.
//

import Foundation
import Alamofire

class NetworkProvider: NetworkProviderErrorHandler {
    
    // MARK: - Properties
    
    var delegate: NetworkProviderDelegate?
    
    private var url: String { "\(marvelAPI.domain)\(marvelAPI.path)\(marvelSections.characters)" }
    private var parameters = ["apikey": marvelAPI.publicKey,
                              "ts": marvelAPI.ts,
                              "hash": marvelAPI.hash]

    // MARK: - Functions
    
    func fetchData(characterName: String?, completion: @escaping ([Character]) -> ()) {
        if let name = characterName {
            switch name {
            case "":
                parameters.removeValue(forKey: "nameStartsWith")
            default:
                parameters["nameStartsWith"] = name
            }
        }
    
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case .success:
                    print("Validation Successful")
                    print(self.url, self.parameters)
                case let .failure(error):
                    self.delegate?.showAlert(message: error.errorDescription?.description)
                }
            }
            .responseDecodable(of: MarvelAPI.self) { (response) in
                guard let characters = response.value?.data else { return }
                
                if characters.count == 0 {
                    self.delegate?.showAlert(message: nil)
                }
                completion(characters.all)
       }
    }
}

extension NetworkProvider {
    enum marvelAPI {
        static let domain = "https://gateway.marvel.com"
        static let path = "/v1/public/"
        
        static let privateKey = "d6cf8a02889e2d697ba5225c229d2407f63d0dcb"
        static let publicKey = "a2e983bab5bcb623d73e10e4f12c05c1"
        
        static var ts: String {
            return String(Date().getCurrentTimestamp())
            
        }
        
        static var hash: String {
            print("number: \(ts)")
            return String(String(ts) + privateKey + publicKey).md5
        }
    }
    
    enum marvelSections {
        case characters
        case comics
        case creators
        case events
        case series
        case stories
    }
}

