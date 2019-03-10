//
//  CupsManager.swift
//  Recup
//
//  Created by Daniel Montano on 10.03.19.
//  Copyright © 2019 Daniel Montano. All rights reserved.
//

import Foundation

protocol CupsManagerDelegate {
    
    func newCupReturned()
    func newIncomingCup()
}

class CupsManager {
    
    // Singleton implementation
    
    static let sharedInstance = CupsManager()
    private init(){ }
    
    var delegate: CupsManagerDelegate?
    
    // Object Properties
    
    var totalGreenCups: Int = 0
    var totalYellowCups: Int = 0

    var currentCup: String?
    
    func refresh(){
        self.delegate?.newCupReturned()
    }
    
    func handleAcceptTX(cupTX: CupTransaction){
        self.delegate?.newIncomingCup()
    }
    
    func handleReturnTX(cupTX: CupTransaction){
        self.delegate?.newCupReturned()
    }
    
}
