//
//  SeedHelper.swift
//  Recup
//
//  Created by Daniel Montano on 09.03.19.
//  Copyright © 2019 Daniel Montano. All rights reserved.
//

import Foundation
import BitcoinKit
import KeychainAccess

class SeedHelper {
    static let shared = SeedHelper()
    
    let network = Network.testnet
    
    private(set) var wallet: HDWallet? {
        didSet {
            NotificationCenter.default.post(name: Notification.Name.AppController.walletChanged, object: self)
        }
    }
    
    var internalIndex: UInt32 {
        set {
            UserDefaults.standard.set(Int(newValue), forKey: #function)
        }
        get {
            return UInt32(UserDefaults.standard.integer(forKey: #function))
        }
    }
    var externalIndex: UInt32 {
        set {
            UserDefaults.standard.set(Int(newValue), forKey: #function)
        }
        get {
            return UInt32(UserDefaults.standard.integer(forKey: #function))
        }
    }
    
    private init() {
        let keychain = Keychain()
        if let seed = keychain[data: "seed"] {
            self.wallet = HDWallet(seed: seed, network: network)
        }
    }
    
    func importWallet(seed: Data) {
        let keychain = Keychain()
        keychain[data: "seed"] = seed
        
        self.wallet = HDWallet(seed: seed, network: network)
    }
}

extension Notification.Name {
    struct AppController {
        static let walletChanged = Notification.Name("AppController.walletChanged")
        
    }
}

extension Data {
    init?(hex: String) {
        let len = hex.count / 2
        var data = Data(capacity: len)
        for i in 0..<len {
            let j = hex.index(hex.startIndex, offsetBy: i * 2)
            let k = hex.index(j, offsetBy: 2)
            let bytes = hex[j..<k]
            if var num = UInt8(bytes, radix: 16) {
                data.append(&num, count: 1)
            } else {
                return nil
            }
        }
        self = data
    }
    
    var hex: String {
        return reduce("") { $0 + String(format: "%02x", $1) }
    }
}

