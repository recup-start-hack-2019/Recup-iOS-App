//
//  Constants.swift
//  Recup
//
//  Created by Daniel Montano on 09.03.19.
//  Copyright © 2019 Daniel Montano. All rights reserved.
//

import BitcoinKit


class Constants {
    
    // Just for testing during the hackathon
    static let bitcoin = (
        seedWords: ["economy", "clinic", "damage", "energy", "settle", "lady", "crumble", "crack", "valley", "blast", "hair", "double", "cute", "gather", "deer", "smooth", "finish", "ethics", "sauce", "raw", "novel", "hospital", "twice", "actual"],
        network: BitcoinKit.Network.mainnet,
        hdWalletIndex: UInt32(0),
        wif: "L5TEfWGHHUVyt16MbiZiQmANrz8zEaKW2EBKiZRfZ8hbEcy2ymGd",
        publicKey: "030cd0e6d332de86d3c964cac7e98c6b1330154433a8f8aa82a93cbc7a1bfdd45b"
    )
    
}

