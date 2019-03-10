//
//  MainViewController.swift
//  Recup
//
//  Created by Daniel Montano on 09.03.19.
//  Copyright © 2019 Daniel Montano. All rights reserved.
//

import Foundation
import UIKit
import QRCode
import BitcoinKit
import SwiftyJSON
import Alamofire
import LocalAuthentication
import SwiftMessages

class MainViewController: UIViewController {
    
    static let IncomingCupTransaction = Notification.Name(rawValue: "acceptTX")
    static let ReturnCupTransaction = Notification.Name(rawValue: "returnTX")
    
    @IBOutlet weak var qrCodeView: UIImageView!
    
    @IBOutlet weak var cup1: UIImageView!
    @IBOutlet weak var cup2: UIImageView!
    @IBOutlet weak var cup3: UIImageView!
    @IBOutlet weak var cup4: UIImageView!
    @IBOutlet weak var cup5: UIImageView!
    @IBOutlet weak var cup6: UIImageView!
    @IBOutlet weak var cup7: UIImageView!
    @IBOutlet weak var cup8: UIImageView!
    @IBOutlet weak var cup9: UIImageView!
    @IBOutlet weak var cup10: UIImageView!
    @IBOutlet weak var cup11: UIImageView!
    @IBOutlet weak var cup12: UIImageView!
    
    let cup_green_img = UIImage(named: "cup_green")!
    let cup_yellow_img = UIImage(named: "cup_yellow")!
    let cup_grey_img = UIImage(named: "cup_grey")!
    
    var cups: [UIImageView]!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        CupsManager.sharedInstance.delegate = self
        
        self.cups = [cup1,cup2,cup3,cup4,cup5,cup6,cup7,cup8,cup9,cup10,cup11,cup12]
        
        do {
            let mnemonic = try Mnemonic.generate()
            
            // Do any additional setup after loading the view, typically from a nib.
            let seed = Mnemonic.seed(mnemonic: Constants.bitcoin.seedWords)
            SeedHelper.shared.importWallet(seed: seed)
            
            for mnemonic in mnemonic {
                print(mnemonic)
            }
            
            let wallet = BitcoinKit.HDWallet(seed: seed, network: Constants.bitcoin.network)
            
            let privateKey: BitcoinKit.PrivateKey
            let publicKey: BitcoinKit.PublicKey
            privateKey = try wallet.privateKey(index: Constants.bitcoin.hdWalletIndex)
            publicKey = try wallet.publicKey(index: Constants.bitcoin.hdWalletIndex)
            let publicKeyString = publicKey.description
            
            print("result: \(publicKeyString)")
            print("expected: \(Constants.bitcoin.publicKey)")
            
            let message = Crypto.sha256("Hello BitcoinKit".data(using: .utf8)!)
            let signatureData = try BitcoinKit.Crypto.sign(message, privateKey: privateKey)
            
            print("message hash: \(message.hexEncodedString())")
            print("Signature Data: \(signatureData.hexEncodedString())")
            print("result: \(try BitcoinKit.Crypto.verifySignature(signatureData, message: message, publicKey: publicKey.raw))")
            print("")
            
            let qrCodeJSON: JSON = ["publicKey":publicKeyString,"signature":signatureData.hexEncodedString(),"timestamp":Date().timeIntervalSince1970]
            // String
            print("QRCodeString: \(qrCodeJSON.rawString()!)")
            let qrCode = QRCode(qrCodeJSON.rawString()!)
            
            qrCodeView.image = qrCode?.image
            
            // For Debug / Hackathon
//            APIManager.sharedInstance.remoteJSumHelper(senderPubKey: expected.publicKey, receiverPubKey: expected.publicKey, cupqrcode: "sdfsdfsdf", timestamp: 213342345, previousHash: "yvjndfvkjdfvkjdfvkjndkajndfgajndf", type: 2, cb: {(hash,error) in
//
//                print(hash)
//            })
            
        } catch {
            let alert = UIAlertController(title: "Crypto Error", message: "Failed to generate random seed. Please try again later.", preferredStyle: .alert)
            present(alert, animated: true, completion: nil)
        }
        
        self.cups[0].image = cup_green_img
        self.cups[1].image = cup_green_img
        self.cups[2].image = cup_yellow_img
        
        NotificationCenter.default.addObserver( self,
            selector: #selector(MainViewController.incomingTransactionHandler(_:)),
            name: MainViewController.IncomingCupTransaction,
            object: nil)
        NotificationCenter.default.addObserver( self,
                                                selector: #selector(MainViewController.returnedCupTransactionHandler(_:)),
                                                name: MainViewController.ReturnCupTransaction,
                                                object: nil)
        
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func incomingTransactionHandler(_ notification: Notification) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "IncomingCupSegue", sender: self)
        }
    }
    
    @objc func returnedCupTransactionHandler(_ notification: Notification) {
        
    }
    
}

extension MainViewController: CupsManagerDelegate {
    
    func newCupReturned() {
        let view = MessageView.viewFromNib(layout: .cardView)
        view.button?.isHidden = true
        view.configureTheme(.success)
        view.configureDropShadow()
        view.configureContent(title: "Incoming Cup", body: "You have returned a cup!")
        view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        (view.backgroundView as? CornerRoundingView)?.cornerRadius = 10
        
        SwiftMessages.show(view: view)
    }
    
    func newIncomingCup() {
        let view = MessageView.viewFromNib(layout: .cardView)
        view.button?.isHidden = true
        view.configureTheme(.warning)
        view.configureDropShadow()
        view.configureContent(title: "Incoming Cup", body: "A ReCup has been transferred to you!")
        view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        (view.backgroundView as? CornerRoundingView)?.cornerRadius = 10
        
        SwiftMessages.show(view: view)
    }
    
    
}
