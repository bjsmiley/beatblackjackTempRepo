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

//switch (response, error){
//case let (nil, er):
//    print(er!)
//case let (res, nil):
//    let json = res!
//    print(json)
//    print("hi")
//default:
//    return
//}


import UIKit
import Alamofire
import SwiftyJSON

extension UIImageView {
    func loadurl(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBOutlet weak var responseField: UITextView!
    
    
    var deck_id: String?
    
    
    @IBOutlet weak var createLabel: UILabel!
    @IBAction func createDeck() {
        Api.createDeck(deck_count: "1"){ response, error in
            switch (response, error){
            case let (nil, er):
                print(er!)
            case let (res, nil):
                let json = res!
                print(json)
                self.deck_id = json["deck_id"].stringValue
            default:
                return
            }
        }
        
    }
    
    
    
    
    @IBOutlet weak var cardView: UIImageView!
    @IBOutlet weak var countField: UITextField!
    @IBOutlet weak var drawCardLabel: UILabel!
    @IBAction func drawCard() {
        let count = countField.text ?? "1"
        
        Api.drawCard(deck_id: deck_id ?? "unknown", count: count){ response, error in
            switch (response, error){
            case let (nil, er):
                print(er!)
            case let (res, nil):
                let json = res!
                print(json)
                if( json["success"].boolValue ){
                    let arrayCardUrls = json["cards"].arrayValue.map({
                        $0["image"].stringValue
                    })
                    let cardUrl = URL( string: arrayCardUrls[0] )
                    self.cardView.loadurl(url: cardUrl! )
                    self.responseField.text += arrayCardUrls.reduce("",{$0 + " " + $1})
                }
                else{
                    print(json["error"].stringValue)
                }
            default:
                return
            }
        }
    }
    
    
    
    @IBAction func shuffleDeck() {
        Api.shuffleDeck(deck_id: deck_id!){ response, error in
            switch (response, error){
            case let (nil, er):
                print(er!)
            case let (res, nil):
                let json = res!
                print(json)
                print("hi")
            default:
                return
            }
        }
    }
    
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
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

