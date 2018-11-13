//
//  Api.swift
//  beatblackjack
//
//  Created by Bryan Jon Smiley on 11/11/18.
//  Copyright © 2018 SMOP. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


struct Api{
    
    static var baseUrl = "https://deckofcardsapi.com/api/deck/"
    
//    typealias ApiCompetion = (DataResponse<Any>) -> Void
    
    typealias ApiCompletion = (JSON?, Error?) -> Void
    

    static func apiCall( url: String, callback: @escaping ApiCompletion){
        Alamofire.request( url ).validate().responseJSON{ res in
            switch res.result{
            case .success(let value):
                callback( JSON(value) , nil )
            case .failure(let error):
                callback( nil , error )
            }
        }
    }
    
    static func createDeck(deck_count: String, callback: @escaping ApiCompletion){
        let url = "https://deckofcardsapi.com/api/deck/new/shuffle/?deck_count=" + deck_count
        apiCall(url: url, callback: callback)
    }
    
    static func shuffleDeck(deck_id: String, callback: @escaping ApiCompletion){
        let url = baseUrl + deck_id + "/shuffle/"
        apiCall(url: url, callback: callback)
    }
    
    static func drawCard(deck_id: String, count: String, callback: @escaping ApiCompletion){
        let url = baseUrl + deck_id + "/draw/?count=" + count
        apiCall(url: url, callback: callback)
    }
    
    
}
