//
//  Api.swift
//  beatblackjack
//
//  Created by Bryan Jon Smiley on 11/11/18.
//  Copyright © 2018 SMOP. All rights reserved.
//

import Foundation
import Alamofire


struct Api{
    
    static var baseUrl = "https://deckofcardsapi.com/api/deck/"
    
    typealias ApiCompetion = (DataResponse<Any>) -> Void
    
    static func shuffleDeck(deck_id: String, callback: @escaping ApiCompetion){
        let url = baseUrl + deck_id + "/shuffle/"
        
        Alamofire.request( url ).validate().responseJSON(completionHandler: callback)
    }
}
