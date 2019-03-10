//
//  APIManager.swift
//  Recup
//
//  Created by Daniel Montano on 09.03.19.
//  Copyright © 2019 Daniel Montano. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class APIManager {
    
    
    let MyAPI = "ec2-35-165-83-189.us-west-2.compute.amazonaws.com:3000/" // Just during Hackathon
    
    static let sharedInstance = APIManager()
    
    private init(){ }
    
    /// Voll bescheuert - Small workaround during the hackathon
    /// TODO nach dem Hackathon: JSum auf Swift implementieren
    func remoteJSumHelper(senderPubKey: String, receiverPubKey: String, cupqrcode: String, timestamp: Int, previousHash: String,type: Int, cb: @escaping (String?,Error?) -> Void ){
        
        let obj: Parameters = ["senderPublicKey":senderPubKey,
                               "receiverPublicKey":receiverPubKey,
                               "cupqrcode":cupqrcode,
                               "timestamp": timestamp,
                               "previousHash": previousHash,
                               "type":type]
        
        Alamofire.request("ec2-35-165-83-189.us-west-2.compute.amazonaws.com:3000/transactions/jsum", method: .post, parameters: obj).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                cb(json["hash"].rawString(),nil)
            case .failure(let error):
                cb(nil, error)
            }
        }
    }
    
    
    
    
}
