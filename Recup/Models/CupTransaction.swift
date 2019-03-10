//
//  CupTransaction.swift
//  Recup
//
//  Created by Daniel Montano on 10.03.19.
//  Copyright © 2019 Daniel Montano. All rights reserved.
//

import Foundation

struct CupTransaction: Codable {
    
    let cupqrcode: String
    let previousHash: String
    let type: Int
    let receiverPublicKey: String
    let senderPublicKey: String
    let timestamp: Int
    
    @discardableResult
    static func parseCupTransaction(_ notification: [String: AnyObject]) -> CupTransaction? {
        guard let cupqrcode = notification["cupqrcode"] as? String,
            let previousHash = notification["previousHash"] as? String,
            let type = notification["type"] as? Int,
            let receiverPublicKey = notification["receiverPublicKey"] as? String,
            let senderPublicKey = notification["senderPublicKey"] as? String,
            let timestamp = notification["timestamp"] as? Int
        else {
                return nil
        }
        
        let cupTransaction = CupTransaction(cupqrcode: cupqrcode, previousHash: previousHash, type: type, receiverPublicKey: receiverPublicKey, senderPublicKey: senderPublicKey, timestamp: timestamp)
        
        NotificationCenter.default.post(
            name: MainViewController.IncomingCupTransaction,
            object: self)
        
        return cupTransaction
    }
    
    func verifyTransaction(){
        // The signature needs to be valid
    }
    
    func signTransaction() -> String {
        
        var signature = "r343423423423"
        
        return signature
        
    }
}

