//
//  ViewController.swift
//  beatblackjack
//
//  Created by Bryan Jon Smiley on 11/11/18.
//  Copyright © 2018 SMOP. All rights reserved.
//


//  AJAX REQUEST TEMPLATE

//Alamofire.request( url ).validate().responseJSON{ res in
//    switch res.result{
//    case .success(let value):
//        let json = JSON(value)
//        print(json)
//    case .failure(let error):
//        print(error)
//
//    }
//}


import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBOutlet weak var responseField: UITextView!
    
    
    var deck_id: String?
    
    
    @IBOutlet weak var createLabel: UILabel!
    @IBAction func createDeck() {
        createLabel.text = "getting..."
        
        let url = "https://deckofcardsapi.com/api/deck/new/shuffle/?deck_count=1"
        
        Alamofire.request( url ).validate().responseJSON{ res in
            switch res.result{
            case .success(let value):
                let json = JSON(value)
                print(json)
                self.deck_id = json["deck_id"].stringValue
                let bs = json["bullshit"]
                print("bullshit: \(bs)")
            case .failure(let error):
                print(error)
                
            }
            self.createLabel.text = "done!"
        }
        createLabel.text = "wating..."
    }
    
    
    
    
    @IBOutlet weak var countField: UITextField!
    @IBOutlet weak var drawCardLabel: UILabel!
    @IBAction func drawCard() {
        drawCardLabel.text = "getting..."
        
        let count = countField.text ?? "1"
        
        var url = "https://deckofcardsapi.com/api/deck/"
        url += deck_id ?? "unknown"
        url += "/draw/?count="
        url += count
        print("Request sent to: \(url)")
        
        Alamofire.request( url ).validate().responseJSON{ res in
            switch res.result{
            case .success(let value):
                let json = JSON(value)
                print(json)
                if( json["success"].boolValue ){
                    let arrayCardUrls = json["cards"].arrayValue.map({
                        $0["image"].stringValue
                    })
                    self.responseField.text += arrayCardUrls.reduce("",{$0 + " " + $1})
                }
                else{
                    print(json["error"].stringValue)
                }
            case .failure(let error):
                print(error)
                
            }
            self.drawCardLabel.text = "done!"
        }
        drawCardLabel.text = "wating..."
    }
    
    
    
    @IBAction func shuffleDeck() {
        Api.shuffleDeck(deck_id: deck_id!){ res in
            switch res.result{
            case .success(let value):
                let json = JSON(value)
                print(json)
            case .failure(let error):
                print(error)
        
            }
        }
    }
    
    // now make a BETTER API FILE for handling if the api call itself
    // gets an error
    
    // so we then only have to deal with success or failures of a valid
    // api call...
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    @IBOutlet weak var apiDescription: UILabel!
    @IBAction func doGenerictAPIcall() {
        apiDescription.text = "doing api call..."
        
        Alamofire.request("https://httpbin.org/get").validate().responseJSON{ response in
            
            switch response.result {
            case .success(let value):
                print("Validation Successful")
                let json = JSON(value)
                print("JSON: \(json)")
                let url = json["url"]
                print("url: \(url)")
            case .failure(let error):
                print(error)
            }
            
            self.apiDescription.text = "api call returned..."
        }
        
        apiDescription.text = "FINISHED api call..."
    }
    
}

